import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:app_visibility/models/user_update.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  var _name;
  var _phoneNumber;
  var _birthDate;
  bool _status = true;
  FlutterSecureStorage storage = new FlutterSecureStorage();
  final FocusNode myFocusNode = FocusNode();
  Dio dio = new Dio();
  AppRoutes appRoutes = new AppRoutes();
  final _formData = Map<String, Object>();
  String baseUrl = "https://visibility-production-api.herokuapp.com";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future loadFields() async {
    Map<String, String> userData = await storage.readAll();
    String url = '$baseUrl/users/${userData['id']}';
    final response = await dio.get(url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userData['token']}',
          },
        ));

    return response;
  }

  @override
  void initState() {
    super.initState();

    loadFields().then((response) {
      print(response);

      setState(() {
        _name = response.data['name'];
        _phoneNumber = response.data['phone_number'];
        _birthDate = response.data['birth_date'];
      });
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print(_formData['name']);
      print(_formData['phoneNumber']);
      print(_formData['birthDate']);

      final userUpdate = new UserUpdate(
          name: _formData['name'] as String,
          phoneNumber: _formData['phoneNumber'] as String,
          birthDate: _formData['birthDate'] as String);

      Map<String, String> userData = await storage.readAll();

      print(userData['id']);
      print(userUpdate.toJson());

      try {
        print(userData['id']);

        String url = '$baseUrl/users/${userData['id']}';


        await dio.patch(url,
            data: userUpdate.toJson(),
            options: Options(
              headers: {
                'Authorization': 'Bearer ${userData['token']}',
              },
            ));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Informações Pessoais Atualizadas com sucesso.'),
          duration: Duration(seconds: 2),
        ));
      } on DioError catch (error) {
        print(error);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Não foi possível atualizar a senha"),
                content: Text(
                    "Ocorreu um problema ao atualizar informações pessoais."),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            (_name == null && _phoneNumber == null && _birthDate == null)
                ? Padding(
                    padding: const EdgeInsets.all(180.0),
                    child: Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          value: null,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      new Container(
                        height: 180.0,
                        color: Colors.white,
                        child: new Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: new Stack(
                                  fit: StackFit.loose,
                                  children: <Widget>[
                                    new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Container(
                                            width: 140.0,
                                            height: 140.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                image: new ExactAssetImage(
                                                    'assets/profile.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      new Container(
                        color: Color(0xffFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 25.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Informações Pessoais',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _status
                                              ? _getEditIcon()
                                              : new Container(),
                                        ],
                                      )
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Nome',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          initialValue: _name,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Campo Obrigatório';
                                            }
                                            return null;
                                          },
                                          enabled: !_status,
                                          autofocus: !_status,
                                          onSaved: (nome) {
                                            _formData['name'] = nome!;
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Telefone',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          initialValue: _phoneNumber,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Campo Obrigatório';
                                            }
                                            return null;
                                          },
                                          onSaved: (phoneNumber) {
                                            _formData['phoneNumber'] =
                                                phoneNumber!;
                                          },
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Data de Nascimento',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new DateTimePicker(
                                          initialValue: _birthDate,
                                          // icon: Icon(
                                          //     Icons.calendar_today,
                                          //     color: Colors.black,
                                          //   ),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100),
                                          // dateLabelText: 'Data Nascimento',
                                          onSaved: (birthDate) =>
                                              _formData['birthDate'] =
                                                  birthDate!,
                                        ),
                                      ),
                                    ],
                                  )),
                              !_status ? _getActionButtons() : new Container(),
                            ],
                          ),
                        ),
                      ),
                      if (_status) ...[
                        Card(
                          child: ListTile(
                            title: Text('Alterar Senha'),
                            style: ListTileStyle.list,
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                            dense: true,
                            onTap: () => {
                              Navigator.pushNamed(
                                  context, appRoutes.getUpdatePassword)
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: Text('Sair'),
                            style: ListTileStyle.list,
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                            dense: true,
                            onTap: () => {
                              Navigator.pushNamed(context, appRoutes.getLogin)
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Salvar"),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.green,
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0))),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });

                  return _submitForm();
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Cancelar"),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.red,
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0))),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
