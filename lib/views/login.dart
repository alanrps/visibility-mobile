import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:app_visibility/models/authenticate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AppRoutes appRoutes = new AppRoutes();
  Authenticate _formData = new Authenticate();
  final _formKey = GlobalKey<FormState>();
  Dio dio = new Dio();
  String baseUrl = "https://visibility-production-api.herokuapp.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.only(
                  top: 60,
                  left: 40,
                  right: 40,
                ),
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                      height: 70,
                      child: Image.asset('assets/logo-yellow.png'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor digite um email';
                        }

                        return null;
                      },
                      onSaved: (email) =>
                          setState(() => _formData.email = email),
                    ),
                    TextFormField(
                      autofocus: true,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: new TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Senha",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor digite uma senha';
                        }

                        return null;
                      },
                      onSaved: (password) =>
                          setState(() => _formData.password = password),
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style:
                            TextButton.styleFrom(primary: Colors.yellow[700]),
                        child: Text(
                          "Recuperar Senha",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(appRoutes.recoveryPassword);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.3, 1],
                            colors: [
                              Colors.yellow[500]!,
                              Colors.yellow[900]!,
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: SizedBox.expand(
                            child: TextButton(
                                child: Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    Response response = await dio
                                        .post('$baseUrl/authenticate', data: {
                                      'email': _formData.email,
                                      'password': _formData.password
                                    }).catchError((err) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text("Credenciais inválidas"),
                                              content: Text(
                                                  "Usuário ou senha incorreto."),
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
                                    });

                                    print(response.data['token']);

                                    if (response.data['token'] != null) {
                                          final String token = response.data['token'];

                                          _formKey.currentState!.reset();

                                          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

                                          print(decodedToken);

                                          final prefs = await SharedPreferences.getInstance();

                                          prefs.setInt('token', decodedToken['id']);

                                      Navigator.pushReplacementNamed(context, appRoutes.getHome);
                                  }}
                                }
                                ))),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 30,
                      // decoration: BoxDecoration(
                      //   color: Colors.grey,
                      //   borderRadius: BorderRadius.all(Radius.circular(5))
                      // ),
                      child: TextButton(
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            
                          ),
                        ),
                        onPressed: () => 
                          Navigator.of(context).pushNamed(appRoutes.signup),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 550,
                      height: 140,
                      child: Image.asset(
                        'assets/art-yellow.png',
                      ),
                    ),
                  ],
                ))));
  }
}
