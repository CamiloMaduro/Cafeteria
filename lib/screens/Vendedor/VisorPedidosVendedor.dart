import 'package:control_ganadero/services/api_service.dart';
import 'package:control_ganadero/utils/direccionesApi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisorPedidosVendedor extends StatefulWidget {
  final String? userToken;
  final String? nameUser;
  final String? userId;
  final String? empresaId;
  final String? tipoUserId;

  VisorPedidosVendedor({
    this.userToken,
    this.nameUser,
    this.userId,
    this.empresaId,
    this.tipoUserId,
  });

  @override
  _VisorPedidosVendedorState createState() => _VisorPedidosVendedorState();
}

class _VisorPedidosVendedorState extends State<VisorPedidosVendedor> {
  late ApiService apiService;
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> pedidos = [];
  final Map<String, TextEditingController> _quantityControllers =
      {}; // Mapa para manejar los controladores

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl);
    _loadingPedidos();
  }

  Future<void> _loadingPedidos() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      var data = await apiService.getDataPedidos(
        urlgetpedido,
        '1',
        widget.tipoUserId.toString(),
        widget.userToken!,
      );

      if (data.datosEspecie == null || data.datosEspecie!.isEmpty) {
        throw Exception('No se encontraron pedidos.');
      }

      Map<String, List<Map<String, dynamic>>> pedidosPorFecha = {};

      for (var producto in data.datosEspecie!) {
        final fechaOriginal = producto.FechaEntrega ?? 'Sin fecha';
        final fechaFormateada = _formatFecha(fechaOriginal);

        if (!pedidosPorFecha.containsKey(fechaFormateada)) {
          pedidosPorFecha[fechaFormateada] = [];
        }
        pedidosPorFecha[fechaFormateada]?.add({
          'id': producto.Id,
          'nombre': producto.NombreProducto,
          'cantidad': producto.Cantidad,
          'cafeteria': producto.Cafeteria ?? 'Desconocida',
          'fecha': fechaFormateada,
        });
      }

      setState(() {
        pedidos = pedidosPorFecha.entries
            .map((entry) => {'fecha': entry.key, 'productos': entry.value})
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Formatear fecha en español al estilo deseado
  String _formatFecha(String fecha) {
    try {
      final DateTime parsedFecha = DateTime.parse(fecha);
      return DateFormat('EEEE, dd/MM/yyyy').format(parsedFecha);
    } catch (e) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorMessage()
              : pedidos.isEmpty
                  ? _buildEmptyMessage()
                  : _buildPedidoList(),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: Colors.red, size: 48),
          SizedBox(height: 16),
          Text(
            'Ocurrió un error',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _errorMessage ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 16),
          TextButton.icon(
            onPressed: _loadingPedidos,
            icon: Icon(Icons.refresh, color: Colors.blue),
            label: Text(
              'Reintentar',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info, color: Colors.orange, size: 48),
          SizedBox(height: 16),
          Text(
            'Sin pedidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'No se encontraron pedidos en este momento.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPedidoList() {
    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        final fechaFormateada = pedido['fecha'];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.calendar_today, color: Colors.white),
            ),
            title: Text(
              fechaFormateada,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'Productos: ${pedido['productos'].length}',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.blueAccent),
              onPressed: () =>
                  _showPedidoDetalles(context, pedido['productos']),
            ),
          ),
        );
      },
    );
  }

  void _showPedidoDetalles(
      BuildContext context, List<Map<String, dynamic>> productos) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Detalles del Pedido',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productos.map<Widget>((producto) {
                final TextEditingController controller = TextEditingController(
                  text: producto['cantidad'].toString(),
                );
                _quantityControllers[producto['nombre']] = controller;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          producto['nombre'],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: 'Cantidad',
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            producto['cantidad'] =
                                int.tryParse(value) ?? producto['cantidad'];
                            // Imprimir el nombre del producto y la cantidad editada
                            print('Producto editado: ${producto['id']}');
                            print('Producto editado: ${producto['nombre']}');
                            print('Nueva cantidad: ${producto['cantidad']}');
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _guardarPedido(productos);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _guardarPedido(List<Map<String, dynamic>> pedido) async {
    // Aquí puedes agregar la lógica para actualizar los datos, como enviar los cambios a la API.
    // Por ahora, solo actualizamos el estado local.

    List<Map<String, dynamic>> cantidadActualizada = pedido.map((item) {
      return {
        'idProducto': item['id'].toString(),
        'cantidad': item['cantidad'].toString(),
      };
    }).toList();
    var data = await apiService.updateCantidadEntregadas(
      urlupdatepedido,
      cantidadActualizada,
      widget.userToken!,
    );
    print(data.data);
    if (data.data == true) {
      _showSnackBar('Pedido actualizado');
    } else {
      _showSnackBar('Hubo un error con la actualización');
    }
  }

  void _cancelarPedido(Map<String, dynamic> pedido) {
    _showSnackBar('Pedido cancelado: ${pedido['fecha']}');
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.blue,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
