import 'package:control_ganadero/screens/Comprador/MisPedidos.dart';
import 'package:control_ganadero/services/api_service.dart';
import 'package:control_ganadero/utils/direccionesApi.dart';
import 'package:control_ganadero/utils/text_styles.dart';
import 'package:control_ganadero/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreenComprador extends StatefulWidget {
  final String? userToken;
  final String? nameUser;
  final String? userId;
  final String? empresaId;
  final String? tipoUserId;

  HomeScreenComprador({
    this.userToken,
    this.nameUser,
    this.userId,
    this.empresaId,
    this.tipoUserId,
  });

  @override
  _HomeScreenCompradorState createState() => _HomeScreenCompradorState();
}

class _HomeScreenCompradorState extends State<HomeScreenComprador> {
  late ApiService apiService;
  List<Map<String, dynamic>> allDevices = [];
  List<Map<String, dynamic>> cartItems = [];
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredDevices = [];
  bool isLoading = true; // Indicador de carga
  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl);
    _loadingProductos();

    // Inicializamos la lista filtrada con todos los productos

    setState(() {
      filteredDevices =
          allDevices; // Aseguramos que filteredDevices sea una copia
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Establece el escuchador del campo de búsqueda cuando las dependencias cambian
    _setupSearchListener();
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      setState(() {
        String query = _searchController.text.toLowerCase();
        if (query.isEmpty) {
          // Si el campo de búsqueda está vacío, mostramos todos los dispositivos
          filteredDevices = List.from(allDevices);
        } else {
          // Si hay texto, filtramos los dispositivos
          filteredDevices = allDevices
              .where((device) =>
                  device['nombre'].toString().toLowerCase().contains(query))
              .toList();
        }
      });
    });
  }

  Future<void> _loadingProductos() async {
    // Obtén los productos desde la API
    var data = await apiService.getDataProductos(
      urlgetproductos,
      widget.userToken!,
    );

    setState(() {
      allDevices = data.datosEspecie?.map((producto) {
            return {
              'id': producto.Id,
              'nombre': producto.NombreProducto,
              'tipoproducto': producto.TipoProducto,
            };
          }).toList() ??
          [];
      filteredDevices =
          List.from(allDevices); // Inicializa con todos los dispositivos
      isLoading = false; // La carga ha terminado
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _addToCart(Map<String, dynamic> item, int quantity) {
    setState(() {
      var existingItem = cartItems.firstWhere(
        (cartItem) => cartItem['id'] == item['id'],
        orElse: () => {},
      );

      if (existingItem.isEmpty) {
        cartItems.add({...item, 'quantity': quantity});
      } else {
        existingItem['quantity'] = (existingItem['quantity'] as int) + quantity;
      }
    });
  }

  void _removeFromCart(Map<String, dynamic> item) {
    setState(() {
      cartItems.removeWhere((cartItem) => cartItem['id'] == item['id']);
    });
  }

  void _showCartDialog(BuildContext context) {
    // Declaramos selectedDate fuera del StatefulBuilder
    DateTime? selectedDate;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isCartEmpty = cartItems.isEmpty;
            double totalPrice =
                cartItems.fold(0, (sum, item) => sum + (item['quantity']));

            // Función para mostrar el DatePicker
            Future<void> _selectDate(BuildContext context) async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (pickedDate != null) {
                // Actualizamos el estado usando setState del StatefulBuilder
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            }

            // Función para mostrar el resumen del pedido
            void _showOrderSummaryDialog(BuildContext context) {
              if (selectedDate == null) {
                // Mostrar un snackbar si la fecha no está seleccionada
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Por favor, selecciona una fecha de entrega.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Resumen del Pedido'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...cartItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(item['nombre'],
                                      style: const TextStyle(fontSize: 14)),
                                ),
                                Text('x${item['quantity']}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                                // Text(
                                //     '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                //     style: const TextStyle(
                                //         fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }).toList(),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text('${totalPrice}',
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 16)),
                            ],
                          ),
                        ),
                        Text(
                          'Entrega: ${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (cartItems.isNotEmpty) {
                            // Guardar el contexto del widget padre
                            final parentContext = context;

                            String apidir = urlcrearpedido; // La URL de tu API
                            String FechaEntrega = DateFormat('yyyy-MM-dd')
                                .format(selectedDate!); // La fecha seleccionada
                            String Token =
                                widget.userToken!; // El token del usuario
                            String UserId = widget.userId!; // El ID del usuario

                            // Crear lista de productos
                            List<Map<String, dynamic>> productos =
                                cartItems.map((item) {
                              return {
                                'idProducto': item['id'].toString(),
                                'cantidad': item['quantity'].toString(),
                              };
                            }).toList();

                            // Llamada a la API para crear el pedido con varios ítems
                            var data = await apiService.crearPedido(
                              apidir,
                              productos,
                              FechaEntrega,
                              UserId,
                              Token,
                            );

                            // Verificación del resultado
                            if (data.data == true) {
                              // Mostrar un diálogo de éxito
                              await showDialog(
                                context: parentContext,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('¡Pedido Exitoso!'),
                                    content: const Text(
                                        'Tu pedido ha sido creado correctamente.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Cerrar el diálogo
                                        },
                                        child: const Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Mostrar un diálogo de error
                              await showDialog(
                                context: parentContext,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Hubo un problema al crear tu pedido. Intenta nuevamente.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Cerrar el diálogo
                                        },
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            // Cerrar la página después de mostrar el diálogo
                            Navigator.pop(parentContext);
                          }
                        },
                        child: const Text('Confirmar Pedido'),
                      ),
                    ],
                  );
                },
              );
            }

            return AlertDialog(
              title: const Text('Carrito de Compras'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCartEmpty)
                    const Center(
                      child: Text('Tu carrito está vacío',
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                  if (!isCartEmpty)
                    Column(
                      children: [
                        ...cartItems.map((item) {
                          // Controlador de texto para la cantidad
                          TextEditingController quantityController =
                              TextEditingController(
                                  text: item['quantity'].toString());

                          return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Nombre del producto
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      item['nombre'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.025, // Ajuste dinámico
                                      ),
                                      // overflow: TextOverflow
                                      //     .ellipsis, // Truncar texto si es muy largo
                                    ),
                                  ),
                                  // Control de cantidad
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Flexible(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Botón para disminuir la cantidad
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.redAccent),
                                            onPressed: () {
                                              setState(() {
                                                int currentQuantity =
                                                    int.tryParse(
                                                            quantityController
                                                                .text) ??
                                                        1;
                                                if (currentQuantity > 1) {
                                                  currentQuantity -= 1;
                                                  quantityController.text =
                                                      currentQuantity
                                                          .toString();
                                                  item['quantity'] =
                                                      currentQuantity;
                                                } else {
                                                  _removeFromCart(item);
                                                }
                                              });
                                            },
                                          ),
                                          // Campo de texto para mostrar y editar la cantidad
                                          SizedBox(
                                            width: 10,
                                            child: TextField(
                                              controller: quantityController,
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035,
                                              ), // Ajuste dinámico
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8),
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  int newQuantity =
                                                      int.tryParse(value) ?? 1;
                                                  item['quantity'] =
                                                      newQuantity > 0
                                                          ? newQuantity
                                                          : 1;
                                                });
                                              },
                                            ),
                                          ),
                                          // Botón para aumentar la cantidad
                                          IconButton(
                                            icon: const Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.green),
                                            onPressed: () {
                                              setState(() {
                                                int currentQuantity =
                                                    int.tryParse(
                                                            quantityController
                                                                .text) ??
                                                        1;
                                                currentQuantity += 1;
                                                quantityController.text =
                                                    currentQuantity.toString();
                                                item['quantity'] =
                                                    currentQuantity;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Precio total del producto
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      "${item['quantity']}",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035, // Ajuste dinámico
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  // Botón para eliminar el producto
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        _removeFromCart(item);
                                      });
                                    },
                                  ),
                                ],
                              ));
                        }).toList(),
                        const Divider(),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueAccent.withOpacity(0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Colors.blueAccent),
                                const SizedBox(width: 10),
                                Text(
                                  selectedDate == null
                                      ? 'Elige la fecha de entrega'
                                      : 'Entrega el: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                                  style:
                                      const TextStyle(color: Colors.blueAccent),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
                ElevatedButton(
                  onPressed: isCartEmpty || selectedDate == null
                      ? null
                      : () {
                          Navigator.pop(context);
                          _showOrderSummaryDialog(context);
                        },
                  child: const Text('Pedir'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddToCartDialog(BuildContext context, Map<String, dynamic> item) {
    TextEditingController quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Agregar al carrito',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cantidad',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      int currentQuantity =
                          int.tryParse(quantityController.text) ?? 1;
                      if (currentQuantity > 1) {
                        quantityController.text =
                            (currentQuantity - 1).toString();
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  SizedBox(
                    width: 60,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      int currentQuantity =
                          int.tryParse(quantityController.text) ?? 1;
                      quantityController.text =
                          (currentQuantity + 1).toString();
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                int quantity = int.tryParse(quantityController.text) ?? 1;
                if (quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor ingrese una cantidad válida')),
                  );
                  return;
                }
                _addToCart(item, quantity);
                Navigator.pop(context);
              },
              child: const Text(
                'Agregar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  int get totalItemsInCart {
    int total = 0;
    cartItems.forEach((item) {
      total += (item['quantity'] is int)
          ? item['quantity'] as int
          : (item['quantity'] as double).toInt();
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 20;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tipyk',
        onLogout: () => _logout(context),
        onPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextStyles.bodyLarge(context, 'Hola,'),
            TextStyles.headlineMedium(context, '${widget.nameUser}'),
            const SizedBox(height: 20),
            // Botón de "Mis Pedidos"
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0), // Márgenes laterales y superior/inferior
              child: SizedBox(
                width: double.infinity, // Ocupar todo el ancho
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Acción del botón
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ConfirmacionPedidoDialog(
                          userId: widget.userId,
                          nameUser: widget.nameUser,
                          empresaId: widget.empresaId,
                          userToken: widget.userToken,
                          tipoUserId: widget.tipoUserId,
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.shopping_cart,
                      size: 24,
                      color: Colors.white), // Icono con tamaño y color
                  label: Text(
                    'Mis Pedidos',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600), // Texto legible
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600], // Color de fondo
                    foregroundColor: Colors.white, // Color del texto
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0), // Altura del botón
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Bordes redondeados
                    ),
                    elevation: 4, // Sombra del botón
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar empanada',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),

            isLoading
                ? Center(
                    child: CircularProgressIndicator()) // Indicador de carga
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredDevices.length,
                      itemBuilder: (context, index) {
                        final device = filteredDevices[index];
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(device['nombre']),
                            subtitle: Text('${device['tipoproducto']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_shopping_cart),
                              onPressed: () {
                                _showAddToCartDialog(context, device);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCartDialog(context),
        backgroundColor: Colors.green,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart,
                size: 30), // Icono más grande para mejor visibilidad
            if (totalItemsInCart > 0)
              Positioned(
                right: 28, // Ajuste para que no quede pegado al borde
                top:
                    -28, // Ajuste para alinearlo bien en la esquina superior derecha
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white,
                        width: 2), // Borde blanco para destacar
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      '$totalItemsInCart',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
