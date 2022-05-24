import 'dart:async';
import 'package:app_visibility/shared/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/models/marker.dart';
import 'package:app_visibility/utils/utils.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_visibility/utils/notification_service.dart';

class FormUpdateMark extends StatefulWidget {
  @override
  _FormUpdateMark createState() => _FormUpdateMark();
}

class _FormUpdateMark extends State<FormUpdateMark> {
  AppRoutes appRoutes = new AppRoutes();
  Dio dio = new Dio();
  Marker marker = new Marker();
  FlutterSecureStorage storage = new FlutterSecureStorage();
  String? _classify;
  String? _category;
  String? _spaceType;
  String? _name;
  String? _description;
  int? _markerId;
  bool _inProgress = false;
  bool _isValid = true;
  String? _dropDownErrorAcessibilityType;
  String? _dropDownErrorCategory;
  String? _dropDownErrorSpaceType;
  double heightSizedBox = 150;


  FocusNode? focusNode1;
  FocusNode? focusNode2;
  FocusNode? focusNode3;
  FocusNode? focusNode4;
  FocusNode? focusNode5;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    focusNode4 = FocusNode();
    focusNode5 = FocusNode();
  }

  String? _selectedAcessibilityType;
  Map<String, String> accessibilityTypes = {
    'Acessível': 'ACCESSIBLE',
    'Não acessível': 'NOT ACCESSIBLE',
    'Parcialmente': 'PARTIALLY'
  };

  Map<String, String> acessibilityTypesEnglish = {
    'ACCESSIBLE': 'Acessível',
    'NOT ACCESSIBLE': 'Não acessível',
    'PARTIALLY': 'Parcialmente'
  };

  String? _selectedScapeType;
  Map<String, String> spaceTypes = {'Privado': 'PRIVATE', 'Público': 'PUBLIC'};
  Map<String, String> spaceTypeMapEnglish = {
    'PRIVATE': 'Privado',
    'PUBLIC': 'Público',
  };

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
  Map<String, String> categoriesEnglish = {
    'TRAVEL': 'Viagem',
    'TRANSPORT': 'Transporte',
    'SUPERMARKET': 'Supermercado',
    'SERVICES': 'Serviços',
    'LEISURE': 'Lazer',
    'EDUCATION': 'Educação',
    'FOOD': 'Alimentação',
    'HOSPITALS': 'Hospitais',
    'ACCOMMODATION': 'Hospedagem',
  };

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
    _verifyDropDownAcessibilityType();
    _verifyDropDownCategory();
    _verifyDropDownSpaceType();

    if (_isValid && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, String> userData = await storage.readAll();

      Map<String, dynamic> markerData = {
          'name': this._name,
          'description': this._description,
          'spaceType': spaceTypes[_selectedScapeType!],
          'classify': accessibilityTypes[_selectedAcessibilityType!],
          'categoryId': categories[_selectedCategory!],
          // 'user_id': int.parse(userData['id'] as String),
      };

      print(markerData);

      try {
        final String urlUpdateMarker = '${Config.baseUrl}/markers/${this._markerId}';
        String urlUpdateInformationsAmount = '${Config.baseUrl}/users/${userData['id']}/informationAmount';

        Response resultUpdateMarker = await dio.patch(urlUpdateMarker,
            data: markerData,
            options: Options(
              headers: {
                'Authorization': 'Bearer ${userData['token']}',
              },
            ));

        print(resultUpdateMarker.data);
        
         final informationAmount = await dio.patch(urlUpdateInformationsAmount, data: <String, dynamic>{ 
          "updatedProperties": ['edit_evaluations'],
          "currentAction": "EE"
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
        content: Text('Marcação Atualizada com sucesso!'),
        duration: Duration(seconds: 2),
      ));
      Navigator.pop(context, {
        // 'name': this._name,
        // 'description': this._description,
        // 'spaceType': spaceTypes[_selectedScapeType!],
        // 'classify': accessibilityTypes[_selectedAcessibilityType!],
        'category': categories[_selectedCategory!],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    if (arguments != null && _selectedAcessibilityType == null && _selectedCategory == null && _selectedScapeType == null && _name == null && _description == null) {
      _markerId = arguments["markerId"];
      print("MARKER ID DO PAI");
      print(_markerId);

      setState(() {
        _selectedAcessibilityType = acessibilityTypesEnglish[arguments['classify']];
        _selectedCategory = categoriesEnglish[arguments['category']];
        _selectedScapeType = spaceTypeMapEnglish[arguments['spaceType']];
        _name = arguments['name'];
        _description = arguments['description'];
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Atualização de Localização'),
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
                    if (this._selectedAcessibilityType != null &&
                        this._selectedCategory != null &&
                        this._selectedScapeType != null) ...[
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: focusNode1,
                        onTap: () => focusNode1?.requestFocus(),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        initialValue: arguments?['name'],
                        style: new TextStyle(color: Colors.black, fontSize: 20),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo Obrigatório';
                          }
                          return null;
                        },
                        onSaved: (String? newName) =>
                            setState(() => this._name = newName),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Nome do local",
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
                        focusNode: focusNode2,
                        onTap: () => focusNode2?.requestFocus(),
                        maxLines: heightSizedBox ~/ 20,
                        maxLength: 300,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.name,
                        initialValue: arguments?['description'],
                        style: new TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo Obrigatório';
                          }
                          return null;
                        },
                        onSaved: (String? newDescriptionPlace) {
                          this._description = newDescriptionPlace;
                        },
                        decoration: InputDecoration(
                          labelText: "Descrição do local",
                          border: OutlineInputBorder(),
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
                          focusNode: focusNode3,
                          onTap: () => focusNode3?.requestFocus(),
                          isExpanded: true,
                          value: _selectedAcessibilityType,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.yellow[700],
                          ),
                          onChanged: (String? selectedAcessibleType) {
                            print(selectedAcessibleType);
                            setState(() {
                              _selectedAcessibilityType = selectedAcessibleType;
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
                          focusNode: focusNode4,
                          onTap: () => focusNode4?.requestFocus(),
                          isExpanded: true,
                          value: _selectedCategory, //selectedCategory.first,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.yellow[700],
                          ),
                          onChanged: (String? selectedCategory) {
                            setState(() {
                              _selectedCategory = selectedCategory;
                            });
                          },
                          hint: Text(
                            "Categorias",
                            style: TextStyle(color: Colors.black),
                          ),
                          items: (categories.keys).toList().map((String items) {
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
                          focusNode: focusNode5,
                          onTap: () => focusNode5?.requestFocus(),
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
                          items: (spaceTypes.keys).toList().map((String items) {
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
                    ] else ...[
                      CircularProgressIndicator(
                        color: Colors.black,
                        value: null,
                      )
                    ]
                  ],
                ),
              ),
            ),
          )),
          TextButton.icon(
            icon: Icon(Icons.create_sharp),
            label: Text('Atualizar'),
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
