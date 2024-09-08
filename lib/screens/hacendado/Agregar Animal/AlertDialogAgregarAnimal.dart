import 'dart:io';
import 'package:control_ganadero/models/trueFalseGo.dart';
import 'package:intl/intl.dart';
import 'package:control_ganadero/utils/JSONLIST.dart';
import 'package:control_ganadero/utils/customDropDown.dart';
import 'package:control_ganadero/utils/direccionesApi.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:control_ganadero/services/api_service.dart';

class AlertDialogAgregarAnimal extends StatefulWidget {
  final String token;
  final String userId;

  const AlertDialogAgregarAnimal({
    Key? key,
    required this.token,
    required this.userId,
  }) : super(key: key);

  @override
  State<AlertDialogAgregarAnimal> createState() =>
      _AlertDialogAgregarAnimalState();
}

class _AlertDialogAgregarAnimalState extends State<AlertDialogAgregarAnimal> {
  List<DropdownMenuItem<String>> especies = [];
  List<DropdownMenuItem<String>> raza = [];
  List<DropdownMenuItem<String>> estado = [];
  List<DropdownMenuItem<String>> genero = [];
  String? selectedEspecie;
  String? selectedRaza;
  String? selectedEstado;
  String? selectedGenero;
  bool cargueEspecies = false;
  bool cargueRaza = false;
  bool cargueEstado = false;
  bool cargueGenero = false;

  String? _fechaNacimiento;
  String? _fechaIngreso;
  File? _image;
  String? _imageUrl;
  final TextEditingController controllerNombre = TextEditingController();
  final TextEditingController controllerNumeroDeIdentificacion =
      TextEditingController();
  final TextEditingController controllerPesoInicial = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEspecies();
    _loadEstado();
    _loadSexo();
  }

  Future<void> _loadEspecies() async {
    try {
      especies =
          await JSON.GetDatoDropGeneral(urlgetespecie, widget.token, context);
      setState(() {
        cargueEspecies = true;
      });
    } catch (e) {
      print('Error al obtener especies: $e');
    }
  }

  Future<void> _loadRaza(String selectedEspecie) async {
    try {
      raza = await JSON.GetDatoBusqueda(
          urlgetraza, widget.token, selectedEspecie, context);
      setState(() {
        cargueRaza = true;
      });
    } catch (e) {
      print('Error al obtener razas: $e');
    }
  }

  Future<void> _loadEstado() async {
    try {
      estado =
          await JSON.GetDatoDropGeneral(urlgetestado, widget.token, context);
      setState(() {
        cargueEstado = true;
      });
    } catch (e) {
      print('Error al obtener estado: $e');
    }
  }

  Future<void> _loadSexo() async {
    try {
      genero =
          await JSON.GetDatoDropGeneral(urlgetgenero, widget.token, context);
      setState(() {
        cargueGenero = true;
      });
    } catch (e) {
      print('Error al obtener género: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime? currentDate,
      ValueChanged<String?> onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      onDateSelected(formattedDate);
    }
  }

  Future<void> _uploadImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      setState(() {
        _image = null;
        _imageUrl = null; // Ensure that _imageUrl is also set to null if no image is picked
      });
      return;
    }

    File imageFile = File(pickedFile.path);

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child('images/${DateTime.now().toIso8601String()}');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _image = imageFile;
        _imageUrl = imageUrl;
      });
    } catch (e) {
      print('Error al subir la imagen: $e');
    }
  }

  Future<void> _crearAnimal() async {
    if (_fechaNacimiento == null ||
        _fechaIngreso == null ||
        selectedEspecie == null ||
        selectedRaza == null ||
        selectedEstado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, completa todos los campos.')));
      return;
    }

    try {
      var response = await ApiService(baseUrl).crearAnimal(
        urlcrearanimal,
        controllerNombre.text,
        controllerNumeroDeIdentificacion.text,
        _fechaNacimiento!,
        selectedGenero!, // Id Sexo (según tu lógica, se puede cambiar si es dinámico)
        selectedRaza!,
        '1',
        widget.userId,
        _fechaIngreso!,
        controllerPesoInicial.text,
        selectedEstado!,
        _imageUrl, // Envía _imageUrl directamente, puede ser null si no se tomó una foto
        widget.userId,
        widget.token,
      );
      print(response.data);
      if (response.data == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Animal creado exitosamente.')));
        // Limpiar campos
        controllerNombre.clear();
        controllerNumeroDeIdentificacion.clear();
        controllerPesoInicial.clear();
        setState(() {
          _fechaNacimiento = null;
          _fechaIngreso = null;
          selectedEspecie = null;
          selectedRaza = null;
          selectedEstado = null;
          selectedGenero = null;
          _image = null;
          _imageUrl = null;
        });
        Navigator.of(context).pop(); // Cerrar el diálogo después de éxito
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al crear el animal.')));
      }
    } catch (e) {
      print('Error al crear el animal: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al crear el animal.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Animal'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: GestureDetector(
                onTap: _uploadImageFromCamera,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _image != null
                      ? FileImage(_image!) as ImageProvider
                      : _imageUrl != null
                          ? NetworkImage(_imageUrl!) as ImageProvider
                          : null,
                  backgroundColor: Colors.grey[200],
                  child: _image == null && _imageUrl == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controllerNombre,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controllerNumeroDeIdentificacion,
              decoration:
                  InputDecoration(labelText: 'Número de Identificación'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _selectDate(context, DateTime.now(), (pickedDate) {
                setState(() {
                  _fechaNacimiento = pickedDate;
                });
              }),
              child: Text(_fechaNacimiento != null
                  ? 'Fecha de Nacimiento: $_fechaNacimiento'
                  : 'Seleccionar Fecha De Nacimiento'),
            ),
            SizedBox(height: 20),
            CustomDropdown(
              especies: genero,
              selectedEspecie: selectedGenero,
              hintText: 'Seleccionar Género',
              onChanged: (value) {
                setState(() {
                  selectedGenero = value;
                });
              },
            ),
            SizedBox(height: 20),
            CustomDropdown(
              especies: especies,
              selectedEspecie: selectedEspecie,
              hintText: 'Seleccionar Especie',
              onChanged: (value) async {
                setState(() {
                  selectedEspecie = value;
                  selectedRaza = null;
                  cargueRaza = false;
                });
                if (value != null) await _loadRaza(value);
              },
            ),
            SizedBox(height: 20),
            cargueRaza
                ? CustomDropdown(
                    especies: raza,
                    selectedEspecie: selectedRaza,
                    hintText: 'Seleccionar Raza',
                    onChanged: (value) {
                      setState(() {
                        selectedRaza = value;
                      });
                    },
                  )
                : SizedBox(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  _selectDate(context, DateTime.now(), (pickedDate) {
                setState(() {
                  _fechaIngreso = pickedDate;
                });
              }),
              child: Text(_fechaIngreso != null
                  ? 'Fecha de Ingreso: $_fechaIngreso'
                  : 'Seleccionar Fecha De Ingreso'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controllerPesoInicial,
              decoration: InputDecoration(labelText: 'Peso Inicial'),
            ),
            SizedBox(height: 20),
            CustomDropdown(
              especies: estado,
              selectedEspecie: selectedEstado,
              hintText: 'Seleccionar Estado',
              onChanged: (value) {
                setState(() {
                  selectedEstado = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _crearAnimal,
              child: Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }
}
