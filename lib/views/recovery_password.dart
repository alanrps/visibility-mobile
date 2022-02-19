import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/models/recovery_password.dart'
    as recoveryPasswordModel;

class RecoveryPassword extends StatefulWidget {
  @override
  _RecoveryPasswordState createState() => new _RecoveryPasswordState();
}

class _RecoveryPasswordState extends State<RecoveryPassword> {
  Dio dio = new Dio();
  String? email;
  final _formKey = GlobalKey<FormState>();
  String baseUrl = "https://visibility-production-api.herokuapp.com";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submitForm() async {
    print(_formKey.currentState!.validate());
    
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = new recoveryPasswordModel.RecoveryPassword(
          email: this.email as String);

      print(user.toJson());

      String url = '$baseUrl/users/${this.email}';

      await dio.patch(url, data: user.toJson());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Um email foi enviado com a nova senha!'),
        duration: Duration(seconds: 2),
      ));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    print(deviceWidth);
    double deviceHeight = MediaQuery.of(context).size.height;

    return Material(
        child: Container(
            padding: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 0),
            color: Colors.grey[100],
            child: new Form(
              key: _formKey,
              child: new ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Text(
                    "Esqueci Minha Senha",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Enviaremos uma senha temporária para o seu email.",
                      style: const TextStyle(
                          fontSize: 20,
                          decorationStyle: TextDecorationStyle.solid),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 320),
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(color: Colors.black),
                      initialValue: this.email,
                      onSaved: (String? email) => this.email = email,
                      validator: (value) {
                        if (value == null || value.isEmpty) 
                          return 'Campo Obrigatório';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(12),
                      width: deviceWidth < 200 ? 80 : deviceWidth * 0.4,
                      height: deviceHeight < 500
                          ? 50
                          : deviceHeight > 800
                              ? 80
                              : deviceHeight * 0.09,
                      child: ElevatedButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            backgroundColor: Colors.yellow[700],
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          child: Text("Enviar para email"),
                          onPressed: _submitForm)),
                ],
              ),
            )));
  }
}
