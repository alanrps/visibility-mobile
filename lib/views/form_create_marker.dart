import 'dart:async';
import 'package:dio/dio.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/models/marker.dart';
import 'package:app_visibility/routes/routes.dart';

class FormCreateMark extends StatefulWidget {
  @override
  _FormCreateMark createState() => _FormCreateMark();
}

class _FormCreateMark extends State<FormCreateMark> {
  Dio dio = new Dio();
  Marker marker = new Marker();
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
  }

  List<String> selectAcessibility = ['Acessível', 'ACCESSIBLE'];
  Map<String, String> accessibilityTypes = {
    'Acessível': 'ACESSIBLE',
    'Não acessível': 'NOT ACCESSIBLE',
    'Parcialmente': 'PARTIALLY'
  };

  List<String> markerTypeSelect = ['Lugar', 'PLACE'];
  Map<String, String> markerTypes = {
    'Lugar': 'PLACE',
    'Vaga de cadeirante': 'WHEELCHAIR_PARKING'
  };

  List<String> spaceTypes = ['Privado', 'Público'];

  void _setPosition(double latitude, double longitude) {
    setState(() {
      marker.latitude = latitude;
      marker.longitude = longitude;
    });
  }

  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    marker.typeMarkerId = markerTypeSelect.last;
    print(selectAcessibility);
    print(marker.typeMarkerId);
    print(marker.latitude);
    print(marker.longitude);
    print(marker.description);
    print(marker.classify);

    // print(marker.descriptionPlace);
    // print(marker.name);
    // Recebendo null
    // print(marker.detailsPlace);
    // print(marker.details);

    // Corrigir validate
    if (_formKey.currentState.validate()) {
      if (marker.typeMarkerId != '') {
        marker.classify = selectAcessibility.last;
      }

      final markerData = {
        'marker': {
          'markers_type_id': marker.typeMarkerId,
        },
        'point_data': {
          'latitude': marker.latitude,
          'longitude': marker.longitude
        },
      };

      if (marker.typeMarkerId == 'PLACE') {
        markerData.addAll({
          'place': {
            'name': marker.name,
            'classify': marker.classify,
            'description': marker.description
          }
        });
      }

      final String url = 'http://192.168.237.70:3000/markers';

      try {
        Response response = await dio.post(url, data: markerData);
      } catch (e) {
        print(e);
      }

      Navigator.pushNamed(context, '/home');

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Processando dados')));

    }

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text("Verifique os dados inseridos"),
    //         // content: Text("Verifique os dados inseridos."),
    //         actions: [
    //           FlatButton(
    //             child: Text("Ok"),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           )
    //         ],
    //       );
    //     });
  }

  Future<LocationData> _getCurrentUserLocation() async {
    final LocationData location = await Location().getLocation();

    return location;
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    print("asdsadsad ${arguments}");

    // if (arguments != null) {
    //   print(arguments['position']);
    //   print(arguments['position']);
    //   _setPosition(
    //       arguments['position'].latitude, arguments['position'].longitude);
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Local'),
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
                          style: (arguments != null || marker.latitude != null)
                              ? TextButton.styleFrom(
                                  primary: Colors.black,
                                  backgroundColor: Colors.grey,
                                  elevation: 0,
                                  padding: const EdgeInsets.all(12),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                )
                              : TextButton.styleFrom(
                                  primary: Colors.black,
                                  backgroundColor: Colors.yellow[700],
                                  elevation: 0,
                                  padding: const EdgeInsets.all(12),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                          child: Text(
                            "Selecionar Localização",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 13),
                          ),
                          onPressed:
                              (arguments != null || marker.latitude != null)
                                  ? null
                                  : () {
                                      Navigator.of(context)
                                          .pushNamed(AppRoutes.MAP);
                                    },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          style: (arguments != null || marker.latitude != null)
                              ? TextButton.styleFrom(
                                  primary: Colors.black,
                                  backgroundColor: Colors.grey,
                                  elevation: 0,
                                  padding: const EdgeInsets.all(12),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                )
                              : TextButton.styleFrom(
                                  primary: Colors.black,
                                  backgroundColor: Colors.yellow[700],
                                  elevation: 0,
                                  padding: const EdgeInsets.all(12),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                          child: Text(
                            "Usar Localização atual",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 13),
                          ),
                          onPressed: (arguments != null ||
                                  marker.latitude != null)
                              ? null
                              : () async {
                                  setState(() {
                                    _inProgress = true;
                                  });

                                  LocationData location =
                                      await this._getCurrentUserLocation();

                                  _setPosition(
                                      location.latitude, location.longitude);

                                  setState(() {
                                    _inProgress = false;
                                  });
                                },
                        ),
                      ],
                    ),
                    if (_inProgress != false) ...[
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(
                        color: Colors.black,
                        value: null,
                      )
                    ],
                    SizedBox(
                      height: 20,
                    ),
                    if (arguments != null || marker.latitude != null) ...[
                      DropdownButton<String>(
                          isExpanded: true,
                          value: markerTypeSelect[0],
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.yellow,
                          ),
                          onChanged: (String selectedMarker) {
                            setState(() {
                              markerTypeSelect[0] = selectedMarker;
                              markerTypeSelect[1] = markerTypes[selectedMarker];
                            });
                          },
                          hint: Text(
                            "Selecione o tipo de local",
                            style: TextStyle(color: Colors.black),
                          ),
                          items:
                              (markerTypes.keys).toList().map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList()),
                      if (markerTypeSelect.first == 'Lugar') ...[
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autofocus: true,
                          keyboardType: TextInputType.name,
                          style:
                              new TextStyle(color: Colors.black, fontSize: 20),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo Obrigatório';
                            }
                            return null;
                          },
                          // onSaved: (String newName) =>
                          //     setState(() => marker.name = newName),
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
                        TextFormField(
                          autofocus: true,
                          keyboardType: TextInputType.name,
                          style:
                              new TextStyle(color: Colors.black, fontSize: 20),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo Obrigatório';
                            }
                            return null;
                          },
                          onChanged: (String newDescriptionPlace) {
                            marker.description = newDescriptionPlace;
                          },
                          decoration: InputDecoration(
                            labelText: "Descrição do lugar",
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
                            value: selectAcessibility.first,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.yellow[700],
                            ),
                            onChanged: (String selectedAcessible) {
                              setState(() {
                                selectAcessibility[0] = selectedAcessible;
                                selectAcessibility[1] =
                                    accessibilityTypes[selectedAcessible];
                              });
                            },
                            hint: Text(
                              "Nível de acessibilidade",
                              style: TextStyle(color: Colors.black),
                            ),
                            items: (accessibilityTypes.keys)
                                .toList()
                                .map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList()),
                      ]
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
