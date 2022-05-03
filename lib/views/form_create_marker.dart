import 'dart:async';
import 'package:app_visibility/shared/config.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/models/marker.dart';
import 'package:app_visibility/utils/utils.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_visibility/formatters/max_length_in_line_formatter.dart';
import 'package:app_visibility/formatters/max_lines_formatter.dart';
import 'package:app_visibility/utils/utils.dart';
import 'package:app_visibility/models/badges.dart';
import 'package:app_visibility/views/achievement_view.dart';
import 'package:app_visibility/utils/notification_service.dart';
import 'dart:io';


class FormCreateMark extends StatefulWidget {
  @override
  _FormCreateMark createState() => _FormCreateMark();
}

class _FormCreateMark extends State<FormCreateMark> {
  AppRoutes appRoutes = new AppRoutes();
  Dio dio = new Dio();
  Marker marker = new Marker();
  FlutterSecureStorage storage = new FlutterSecureStorage();
  bool _inProgress = false;
  bool _isValid = true;
  String? _dropDownErrorMarkerType;
  String? _dropDownErrorAcessibilityType;
  String? _dropDownErrorCategory;
  String? _dropDownErrorSpaceType;
  final TextEditingController controller = TextEditingController();
  final maxLength = 1000;
  String _caractersCount = ''; 

  @override
  void initState() {
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void showSnackBar(BuildContext context, String text) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text),
      ));
  }

  Future<LocationData> _getCurrentUserLocation() async {
    final LocationData location = await Location().getLocation();

    return location;
  }

  String? _selectedAcessibilityType;
  Map<String, String> accessibilityTypes = {
    'Acessível': 'ACCESSIBLE',
    'Não acessível': 'NOT ACCESSIBLE',
    'Parcialmente': 'PARTIALLY'
  };

  String? _selectedMarkerType;
  Map<String, String> markerTypes = {
    'Lugar': 'PLACE',
    'Vaga de cadeirante': 'WHEELCHAIR_PARKING'
  };

  String? _selectedScapeType;
  Map<String, String> spaceTypes = {'Privado': 'PRIVATE', 'Público': 'PUBLIC'};

  String? _selectedCategory;
  Map<String, String> categories = {
    'Viagem': 'TRAVEL',
    'Transporte': 'TRANSPORT',
    'Supermercado': 'SUPERMARKET',
    'Serviços': 'SERVICES',
    'Lazer': 'LEISURE',
    'Educação': 'EDUCATION',
    'Alimentação': 'FOOD',
    'Hospitais': 'HOSPITALS',
    'Hospedagem': 'ACCOMMODATION',
  };

  void _setPosition(double? latitude, double? longitude) {
    setState(() {
      marker.latitude = latitude;
      marker.longitude = longitude;
    });
  }

  // talvez adicionar verificação para quando estiver falso e passar para true
  _verifyDropDownMarkerType() {
    if (_selectedMarkerType != null && _dropDownErrorMarkerType != null) {
      setState(() {
        _dropDownErrorMarkerType = '';
        _isValid = true;
      });
    }
    if (_selectedMarkerType == null) {
      setState(() {
        _dropDownErrorMarkerType = "Por Favor, Selecione um Local";
        _isValid = false;
      });
    }
  }

  _verifyDropDownAcessibilityType() {
    if (_selectedAcessibilityType != null &&
        _dropDownErrorAcessibilityType != null) {
      setState(() {
        _dropDownErrorAcessibilityType = '';
        _isValid = true;
      });
    }
    if (_selectedAcessibilityType == null) {
      setState(() {
        _dropDownErrorAcessibilityType =
            "Por Favor, Selecione o Nível de acessibilidade";
        _isValid = false;
      });
    }
  }

  _verifyDropDownCategory() {
    if (_selectedCategory != null && _dropDownErrorCategory != null) {
      setState(() {
        _dropDownErrorCategory = '';
        _isValid = true;
      });
    }
    if (_selectedCategory == null) {
      setState(() {
        _dropDownErrorCategory = "Por Favor, Selecione a Categoria";
        _isValid = false;
      });
    }
  }

  _verifyDropDownSpaceType() {
    if (_selectedScapeType != null && _dropDownErrorSpaceType != null) {
      setState(() {
        _dropDownErrorSpaceType = '';
        _isValid = true;
      });
    }
    if (_selectedScapeType == null) {
      setState(() {
        _dropDownErrorSpaceType = "Por Favor, Selecione o Tipo de Espaço";
        _isValid = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    print("COUNT");
    print(_caractersCount);

    List<String> updatedProperties = [];
    _verifyDropDownMarkerType();

    if (_selectedMarkerType != null && _selectedMarkerType == 'PLACE') {
      _verifyDropDownAcessibilityType();
      _verifyDropDownCategory();
      _verifyDropDownSpaceType();
    }

    if (_isValid && _formKey.currentState!.validate()) {
      updatedProperties.add('evaluations');
      
      marker.typeMarker = markerTypes[_selectedMarkerType!];

      _formKey.currentState!.save();

      if (marker.typeMarker != 'WHEELCHAIR_PARKING') {
        marker.category = categories[_selectedCategory!];
        marker.spaceType = spaceTypes[_selectedScapeType!];
        marker.classify = accessibilityTypes[_selectedAcessibilityType!];
        updatedProperties.addAll([marker.typeMarker!, marker.category!, 'wheelchair_parking']);
      }

      Map<String, String> userData = await storage.readAll();

      updatedProperties.addAll([marker.typeMarker!]);

      final markerData = {
        'marker': {
          'user_id': int.parse(userData['id'] as String),
          'markers_type_id': marker.typeMarker,
          'category_id': marker.category,
        },
        'point_data': {
          'latitude': marker.latitude,
          'longitude': marker.longitude
        },
      };

      if (marker.typeMarker == 'PLACE') {
        Map<String, String> accessibilityMap = {
          'ACCESSIBLE': 'accessible_place',
          'NOT ACCESSIBLE': 'not_accessible_place',
          'PARTIALLY': 'partially_accessible_place'
        };

        Map<String, String> spaceTypeMap = {
          'PRIVATE': 'private_evaluations',
          'PUBLIC': 'public_evaluations',
        };

        print(accessibilityMap[marker.classify]);
        print(spaceTypeMap[marker.spaceType]!);
        updatedProperties.addAll([
          accessibilityMap[marker.classify]!,
          spaceTypeMap[marker.spaceType]!
        ]);

        markerData.addAll({
          'place': {
            'name': marker.name,
            'classify': marker.classify,
            'description': marker.description,
            'space_type': marker.spaceType,
          }
        });
      }

      try {
        String urlCreateMarker = '${Config.baseUrl}/markers';
        String urlUpdateInformationsAmount = '${Config.baseUrl}/users/${userData['id']}/informationAmount';

        await dio.post(urlCreateMarker,
            data: markerData,
            options: Options(
              headers: {
                'Authorization': 'Bearer ${userData['token']}',
              },
        ));

        final informationAmount = await dio.patch(urlUpdateInformationsAmount, data: <String, dynamic>{ 
          "updatedProperties": Utils.convertListToLowerCase(updatedProperties),
          "currentAction": _caractersCount.length >= 200 ? "EP200" : "EP"
          },
            options: Options(
              headers: {
                'Authorization': 'Bearer ${userData['token']}',
              },
        ));

        print(informationAmount.data[1]);

        final achievements = informationAmount.data[1] as List<dynamic>;
        print(achievements);

        NotificationService n =  NotificationService();
        int counter = 0;                  
        await n.initState();

        if(informationAmount.data[0]['updatedLevel'] == true){
          await n.showNotification(counter, 'Avançou de nível!', 'Parabéns! você atingiu o nível ${informationAmount.data[0]['level']}', 'O pai é brabo mesmo', true);
          counter += 1;
        }
        if(achievements.length >= 1){
          for(Map<String, dynamic> achievement in achievements){
            await n.showNotification(counter, 'Adquiriu uma conquista!', achievement['description'], 'O pai é brabo mesmo', false);
            counter += 1;
          }
        }
      } catch (e) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Marcação Adicionada com sucesso!'),
        duration: Duration(seconds: 2),
      ));
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightSizedBox = 150;
    final int maxLength = 120;
    final int maxLengthInLine = 20;

    final int maxLines = 3;
    final int maxLinesForced = 3;
    final arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    if (arguments != null) {
      print(arguments['latitude']);
      print(arguments['longitude']);

      _setPosition(arguments['latitude'], arguments['longitude']);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Localização'),
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
                                          .pushNamed(appRoutes.getMap);
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
                          value: _selectedMarkerType,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.yellow,
                          ),
                          onChanged: (String? selectedMarkerType) {
                            setState(() {
                              _selectedMarkerType = selectedMarkerType;
                            });
                          },
                          hint: Text(
                            "Tipo de local",
                            style: TextStyle(color: Colors.black),
                          ),
                          items:
                              (markerTypes.keys).toList().map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList()),
                      _dropDownErrorMarkerType == null
                          ? SizedBox.shrink()
                          : Text(
                              _dropDownErrorMarkerType ?? "",
                              style: TextStyle(color: Colors.red),
                            ),
                      if (_selectedMarkerType == 'Lugar') ...[
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          style:
                              new TextStyle(color: Colors.black, fontSize: 20),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo Obrigatório';
                            }
                            return null;
                          },
                          onSaved: (String? newName) =>
                              setState(() => marker.name = newName),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
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
                        Column(
                          children: [
                           TextFormField(
                            maxLength: 300,
                            maxLines: heightSizedBox ~/ 20,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.name,
                            style: new TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo Obrigatório';
                              }
                              return null;
                            },
                            onSaved: (String? newDescriptionPlace) {
                              marker.description = newDescriptionPlace;
                            },
                            onChanged: (String value) {
                              setState(() {
                                _caractersCount = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Descrição do lugar",
                              border: OutlineInputBorder(),
                              counterText: 'Quantidade caracteres: ${_caractersCount.length}',
                              counterStyle: new TextStyle(color: Colors.black, fontSize: 12),
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedAcessibilityType,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.yellow[700],
                            ),
                            onChanged: (String? selectedAcessibleType) {
                              setState(() {
                                _selectedAcessibilityType =
                                    selectedAcessibleType;
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
                        _dropDownErrorAcessibilityType == null
                            ? SizedBox.shrink()
                            : Text(
                                _dropDownErrorAcessibilityType ?? "",
                                style: TextStyle(color: Colors.red),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedCategory, //selectedCategory.first,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.yellow[700],
                            ),
                            onChanged: (String? selectedCategory) {
                              print(selectedCategory);

                              setState(() {
                                _selectedCategory = selectedCategory;
                              });
                            },
                            hint: Text(
                              "Categorias",
                              style: TextStyle(color: Colors.black),
                            ),
                            items:
                                (categories.keys).toList().map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList()),
                        _dropDownErrorCategory == null
                            ? SizedBox.shrink()
                            : Text(
                                _dropDownErrorCategory ?? "",
                                style: TextStyle(color: Colors.red),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedScapeType,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.yellow[700],
                            ),
                            onChanged: (String? selectedSpaceType) {
                              print(selectedSpaceType);

                              setState(() {
                                _selectedScapeType = selectedSpaceType;
                              });
                            },
                            hint: Text(
                              "Tipo de Espaço",
                              style: TextStyle(color: Colors.black),
                            ),
                            items:
                                (spaceTypes.keys).toList().map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList()),
                        _dropDownErrorSpaceType == null
                            ? SizedBox.shrink()
                            : Text(
                                _dropDownErrorSpaceType ?? "",
                                style: TextStyle(color: Colors.red),
                              ),
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
