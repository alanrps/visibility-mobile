import 'package:app_visibility/models/marker.dart';
import 'package:app_visibility/providers/markers.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/routes/routes.dart';

class FormCreateMark extends StatefulWidget {
  @override
  _FormCreateMark createState() => _FormCreateMark();
}

class _FormCreateMark extends State<FormCreateMark> {
  Marker marker = new Marker();

  @override
  void initState() {
    super.initState();
  }

  List<String> markersTypes = ['Lugar', 'Vaga cadeirante'];
  String markerTypeSelect;

  List<String> accessibleType = ['Acessível', 'Não acessível', 'Parcialmente'];
  String accessibleTypeSelect;

  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    marker.typeMarkerId = markerTypeSelect;
    print(marker.typeMarkerId);
    print(marker.latitude);
    print(marker.longitude);
    print(marker.description);

    print(marker.descriptionPlace);
    print(marker.name);

    // Recebendo null
    // print(marker.detailsPlace);
    // print(marker.details);

    if (_formKey.currentState.validate()) {
      if (marker.typeMarkerId != '') {
        marker.classify = accessibleTypeSelect;
      }
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Processando dados')));
    }
    print(marker.classify);
  }

  Future<LocationData> _getCurrentUserLocation() async {
    final LocationData location = await Location().getLocation();

    return location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Marcação'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            backgroundColor: Colors.yellow[700],
                            elevation: 0,
                            padding: const EdgeInsets.all(12),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Selecionar Localização",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 13),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.MAP);
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            backgroundColor: Colors.yellow[700],
                            elevation: 0,
                            padding: const EdgeInsets.all(12),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Usar Localização atual",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 13),
                          ),
                          onPressed: () async {
                            LocationData location =
                                await this._getCurrentUserLocation();

                            // Verificar possível erro ao setar as variáveis
                            marker.latitude = location.latitude;
                            marker.longitude = location.longitude;
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      style: new TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: (String newDescription) {
                        marker.description = newDescription;
                      },
                      decoration: InputDecoration(
                        labelText: "Descrição da Marcação",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: markerTypeSelect,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.yellow[700],
                      ),
                      onChanged: (String selectedMarker) {
                        setState(() {
                          markerTypeSelect = selectedMarker;
                        });
                      },
                      hint: Text(
                        "Selecione o tipo de marcação",
                        style: TextStyle(color: Colors.black),
                      ),
                      items: markersTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    if (markerTypeSelect == 'Lugar') ...[
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        style: new TextStyle(color: Colors.black, fontSize: 20),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo Obrigatório';
                          }
                          return null;
                        },
                        onChanged: (String newName) {
                          marker.name = newName;
                        },
                        decoration: InputDecoration(
                          labelText: "Nome do Lugar",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: accessibleTypeSelect,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.yellow[700],
                        ),
                        onChanged: (String selectedAcessible) {
                          // * String? *
                          setState(() {
                            accessibleTypeSelect =
                                selectedAcessible; // * newValue! *
                          });
                        },
                        hint: Text(
                          "Nível de acessibilidade",
                          style: TextStyle(color: Colors.black),
                        ),
                        items: accessibleType
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        style: new TextStyle(color: Colors.black, fontSize: 20),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo Obrigatório';
                          }
                          return null;
                        },
                        onChanged: (String newDescriptionPlace) {
                          marker.descriptionPlace = newDescriptionPlace;
                        },
                        decoration: InputDecoration(
                          labelText: "Descrição do lugar",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          )),
          TextButton.icon(
            icon: Icon(Icons.add),
            label: Text('Adicionar'),
            style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.yellow[700],
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }
}
