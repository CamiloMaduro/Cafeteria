import 'package:control_ganadero/screens/Vendedor/VisorPedidosVendedor.dart';
import 'package:flutter/material.dart';
import 'package:control_ganadero/services/api_service.dart';
import 'package:control_ganadero/utils/direccionesApi.dart';
import 'package:control_ganadero/utils/text_styles.dart';
import 'package:intl/intl.dart';

class HomeScreenVendedor extends StatefulWidget {
  final String? userToken;
  final String? nameUser;
  final String? userId;
  final String? empresaId;
  final String? tipoUserId;

  HomeScreenVendedor(
      {this.userToken,
      this.nameUser,
      this.userId,
      this.empresaId,
      this.tipoUserId});

  @override
  _HomeScreenVendedorState createState() => _HomeScreenVendedorState();
}

class _HomeScreenVendedorState extends State<HomeScreenVendedor> {
  late ApiService apiService;
  int? TotalVentas;
  int? TotalProductosVendidos;
  String? productosMensualesVendidos;
  TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl);
    _loadingVentasMensuales();
    _loadingProductosMensualesVendidos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadingVentasMensuales() async {
    var dataVentasMensuales = await apiService.getDataVentasMes(
      urlgetventasmensuales,
      ' ',
      ' ',
      widget.userToken!,
    );
    setState(() {
      TotalVentas = dataVentasMensuales.datosEspecie![0].TotalVentas!;
    });
  }

  Future<void> _loadingProductosMensualesVendidos() async {
    var dataProductosMensualesVendidos =
        await apiService.getDataVentasProductosMes(
      urlgetproductosvendidosmensuales,
      ' ',
      ' ',
      widget.userToken!,
    );

    setState(() {
      TotalProductosVendidos = dataProductosMensualesVendidos
          .datosEspecie![0].TotalProductosVendidos!;
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 20;
    Widget _buildStatisticCard(
        String title, String subtitle, IconData icon, Color iconColor) {
      return Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: Icon(icon, size: 40, color: iconColor),
          title: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
          tileColor: iconColor.withOpacity(0.1),
        ),
      );
    }

    // Contenido de las estadísticas de negocio
    Widget businessStatistics() {
      String formattedVentas =
          NumberFormat('#,##0.00', 'en_US').format(TotalVentas);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estadísticas del Negocio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),
          // Tarjetas con estadísticas
          _buildStatisticCard('Ventas del mes', 
              'Total de ventas: \$$formattedVentas', Icons.sell, Colors.green),
          _buildStatisticCard(
              'Productos vendidos',
              'Total productos: $TotalProductosVendidos',
              Icons.local_offer,
              Colors.orange),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: const Text(
          'Tipyk',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: _selectedIndex == 0
              ? const Icon(Icons.logout, color: Colors.black)
              : const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_selectedIndex == 0) {
              // Si estás en el inicio, cierra la sesión
              _logout(context);
            } else {
              // Si no estás en el inicio, regresa al inicio
              setState(() {
                _selectedIndex = 0;
              });
            }
          },
        ),
        actions: [
          // Mostrar el icono de menú solo en pantallas pequeñas (móviles)
          if (MediaQuery.of(context).size.width <= 600)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                // Mostrar las opciones de navegación en un BottomSheet en lugar de Drawer
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: ListView(
                        children: [
                          ListTile(
                            title: const Text('Inicio',
                                style: TextStyle(fontSize: 18)),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Pedidos',
                                style: TextStyle(fontSize: 18)),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Agregar Producto',
                                style: TextStyle(fontSize: 18)),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 2;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Agregar Empresa',
                                style: TextStyle(fontSize: 18)),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 3;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Editar Producto',
                                style: TextStyle(fontSize: 18)),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 4;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth <= 600;

          return Row(
            children: [
              // En pantallas grandes (> 600px), usar NavigationRail
              if (!isMobile)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Inicio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.restaurant_menu),
                      label: Text('Pedidos'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.add),
                      label: Text('Agregar Producto'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.business),
                      label: Text('Agregar Empresa'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.edit),
                      label: Text('Editar Producto'),
                    ),
                  ],
                ),
              // Cuerpo principal
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyles.bodyLarge(context, 'Hola,'),
                      TextStyles.headlineMedium(context, '${widget.nameUser}'),
                      const SizedBox(height: 20),
                      // Mostrar las estadísticas si la opción seleccionada es la de estadísticas
                      if (_selectedIndex == 0) businessStatistics(),
                      if (_selectedIndex == 1)
                        VisorPedidosVendedor(
                          userToken: widget.userToken,
                          nameUser: widget.nameUser,
                          userId: widget.userId,
                          empresaId: widget.empresaId,
                          tipoUserId: widget.tipoUserId,
                        ),

                      if (_selectedIndex == 2)
                        const Center(child: Text('Agregar Producto')),
                      if (_selectedIndex == 3)
                        const Center(child: Text('Agregar Empresa')),
                      if (_selectedIndex == 4)
                        const Center(child: Text('Editar Producto')),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
