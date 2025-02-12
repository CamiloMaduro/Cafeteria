import 'dart:io';
import 'package:control_ganadero/services/api_service.dart';
import 'package:control_ganadero/utils/direccionesApi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ConfirmacionPedidoDialog extends StatefulWidget {
  final String? userToken;
  final String? nameUser;
  final String? userId;
  final String? empresaId;
  final String? tipoUserId;

  ConfirmacionPedidoDialog({
    this.userToken,
    this.nameUser,
    this.userId,
    this.empresaId,
    this.tipoUserId,
  });

  @override
  _ConfirmacionPedidoDialogState createState() =>
      _ConfirmacionPedidoDialogState();
}

class _ConfirmacionPedidoDialogState extends State<ConfirmacionPedidoDialog> {
  late ApiService apiService;
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> pedidos = [];

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

  /// Formatear fecha en español al estilo deseado
  String _formatFecha(String fecha) {
    try {
      // Convertir el string de fecha a DateTime
      final DateTime parsedFecha = DateTime.parse(fecha);

      // Formatear la fecha usando intl
      return DateFormat('EEEE, dd/MM/yyyy').format(parsedFecha);
    } catch (e) {
      // Si hay error, devolver la fecha original sin formatear
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
      ),
      body: _isLoading
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
          child: ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.blue),
            title: Text(
              fechaFormateada,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Productos: ${pedido['productos'].length}',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    try {
                      // Asegurar que el valor de 'fecha' sea interpretado correctamente
                      DateTime fecha;
                      if (pedido['fecha'] is String) {
                        // Ajustar el patrón para que coincida con el formato del valor
                        fecha = DateFormat('EEEE, dd/MM/yyyy')
                            .parse(pedido['fecha']);
                      } else if (pedido['fecha'] is DateTime) {
                        fecha = pedido['fecha'];
                      } else {
                        throw Exception('Formato de fecha no compatible.');
                      }

                      // Formatear la fecha al formato esperado por la API (yyyy-MM-dd)
                      var fechaFormateada =
                          DateFormat('yyyy-MM-dd').format(fecha);

                      // Llamar a la API
                      var response = await apiService.pedidoConfirmado(
                        urlpedidoconfirmacion,
                        fechaFormateada,
                        widget.userToken!,
                      );

                      // Procesar la respuesta
                      if (response.data == true) {
                        _confirmarPedido(pedido);
                      }
                    } catch (e) {
                      print('Error al procesar la fecha o la solicitud: $e');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    _cancelarPedido(pedido);
                  },
                ),
              ],
            ),
            onTap: () {
              _showPedidoDetalles(context, pedido['productos']);
            },
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
          title: const Text('Detalles del Pedido'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productos.map<Widget>((producto) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${producto['nombre']} x${producto['cantidad']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cafetería: ${producto['cafeteria']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarPedido(Map<String, dynamic> pedido) async {
    // Generar el PDF
    final pdf = pw.Document();

    // Cargar las imágenes desde los assets
    final ByteData logoData =
        await rootBundle.load('assets/images/encabezado_tipyk.png');
    final ByteData footerImageData =
        await rootBundle.load('assets/images/footer.png');

    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final Uint8List footerImageBytes = footerImageData.buffer.asUint8List();

    final pw.MemoryImage logo = pw.MemoryImage(logoBytes);
    final pw.MemoryImage footerImage = pw.MemoryImage(footerImageBytes);

    // Agregar una página al PDF
    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          final cafeteria =
              pedido['cafeteria'] ?? 'Desconocida'; // Verifica que no sea null

          return pw.Stack(
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Header(
                    child: pw.Image(logo),
                    margin: pw.EdgeInsets.zero,
                  ),
                  pw.SizedBox(height: 16),
                  pw.Text(
                    'Resumen del Pedido',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue, // Cambia el color si es necesario
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Text(
                    'Fecha del Pedido: ${pedido['fecha']}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Punto De: $cafeteria', // Usa la variable `cafeteria`
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Productos:',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  pw.ListView.builder(
                    itemCount: pedido['productos'].length,
                    itemBuilder: (context, index) {
                      final producto = pedido['productos'][index];
                      return pw.Text(
                        'Producto: ${producto['nombre']}, Cantidad: ${producto['cantidad']} Unidades',
                        style: pw.TextStyle(fontSize: 14),
                      );
                    },
                  ),
                  pw.SizedBox(height: 16), // Espaciado antes del pie de página
                ],
              ),
              // Asegúrate de que la imagen esté al final
              pw.Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: pw.Image(footerImage),
              ),
            ],
          );
        },
      ),
    );

    // Guardar el PDF generado
    final pdfBytes = await pdf.save();

    if (kIsWeb) {
      _descargarPDFWeb(pdfBytes, pedido); // Manejo en la web
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      await _guardarYPCompartirPDF(
          pdfBytes, pedido); // Manejo en dispositivos móviles
    } else {
      // Puedes manejar otras plataformas si es necesario
      print("Plataforma no soportada para descarga/compartición");
    }
  }

// Descargar PDF en web
  void _descargarPDFWeb(Uint8List pdfBytes, Map<String, dynamic> pedido) {
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = '_blank'
      ..download = 'pedido_${pedido['fecha']}.pdf'
      ..click();

    html.Url.revokeObjectUrl(url);
  }

// Guardar y compartir PDF en móvil/escritorio
  Future<void> _guardarYPCompartirPDF(
      Uint8List pdfBytes, Map<String, dynamic> pedido) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/pedido_${pedido['fecha']}.pdf';

      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Compartir el archivo
      await Share.shareFiles([filePath], text: 'Resumen del pedido generado.');
    } catch (e) {
      debugPrint('Error al guardar/compartir el PDF: $e');
    }
  }

  void _cancelarPedido(Map<String, dynamic> pedido) {
    // setState(() {
    //   // Aquí puedes añadir lógica para actualizar el estado local o enviar cambios al servidor
    //   pedidos.remove(pedido);
    // });

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
