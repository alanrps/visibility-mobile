import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:app_visibility/models/authenticate.dart';
import 'package:app_visibility/shared/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AppRoutes appRoutes = new AppRoutes();
  Authenticate _formData = new Authenticate();
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  Dio dio = new Dio();
  bool _inProgress = false;

  Future submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _inProgress = true;
      });

      Response response = await dio.post('${Config.baseUrl}/authenticate', data: {
        'email': _formData.email,
        'password': _formData.password
      }).catchError((err) {
        setState(() {
          _inProgress = false;
        });

        print(err);

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Credenciais inválidas"),
                content: Text("Senha incorreta."),
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

        await storage.write(key: 'id', value: decodedToken['id'].toString());
        await storage.write(key: 'token', value: response.data['token']);
        await storage.write(key: 'name', value: decodedToken['name']);

        Navigator.pushReplacementNamed(context, appRoutes.getHome);
      }
      setState(() {
          _inProgress = false;
      });
    }
  }

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
                          Navigator.of(context)
                              .pushNamed(appRoutes.recoveryPassword);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    if (_inProgress == true) ...[
                        Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              value: null,
                            ),
                          ),
                        ),
                         SizedBox(
                          height: 40,
                        ),
                    ],
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
                                onPressed: () => submitForm()))),
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
