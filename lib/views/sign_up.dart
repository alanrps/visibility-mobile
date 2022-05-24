import 'package:location/location.dart';

import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:app_visibility/shared/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Dio dio = new Dio();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object?>();

  Gender? _userGender = Gender.MALE;
  bool _showPassword = false, _showPasswordConfirmation = false;

  final ButtonStyle style = ElevatedButton.styleFrom(
    primary: Colors.lightGreen[700],
    onPrimary: Colors.white,
    padding: EdgeInsets.all(24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );

  void _submitForm() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();

      User user = new User(
        name: _formData['name'] as String?,
        gender: EnumToString.convertToString(_userGender),
        birthDate: _formData['birthDate'] as String?,
        phoneNumber: _formData['phoneNumber'] as String?,
        email: _formData['email'] as String?,
        password: _formData['password'] as String?,
      );

      print(user.toJson());
      
      try {
        String url = '${Config.baseUrl}/users';
        
        await dio.post(url, data: user.toJson());
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Usuário criado com sucesso!'),
        duration: Duration(seconds: 2),
      ));

      Navigator.pop(context);

      } on DioError catch (error) {
        print(error);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text("Dados inválidos"),
              content: Text(
                  "Já existe uma conta vinculada a esse email."),
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
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Criar conta'),
          backgroundColor: Colors.yellow[700],
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
              key: _form,
              child: ListView(scrollDirection: Axis.vertical,
               children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'campo obrigatório';
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    labelText: 'Nome',
                  ),
                  onSaved: (value) => _formData['name'] = value,
                ),
                Column(
                  children: [
                    SizedBox(height: 24),
                    Row(children: <Widget>[
                      Text(
                        'Gênero',
                        style: TextStyle(
                          fontSize: 16,
                          foreground: Paint()..color = Colors.grey[600]!,
                        ),
                      )
                    ]),
                    ListTile(
                      title: const Text('Homem'),
                      leading: Radio<Gender>(
                        value: Gender.MALE,
                        groupValue: _userGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _userGender = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Mulher'),
                      leading: Radio<Gender>(
                        value: Gender.FEMALE,
                        groupValue: _userGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _userGender = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Outro'),
                      leading: Radio<Gender>(
                        value: Gender.OTHER,
                        groupValue: _userGender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _userGender = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                DateTimePicker(
                  initialValue: '',
                  icon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Data Nascimento',
                  onSaved: (val) => _formData['birthDate'] = val,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    String patttern = r'(^[0-9]*$)';
                    RegExp regExp = new RegExp(patttern);
                    if (value!.length == 0)
                      return "Informe o celular";
                    else if (value.length != 10 && value.length != 11)
                      return "O telefone deve ter 10 ou 11 dígitos";
                    else if (!regExp.hasMatch(value))
                      return "O número do celular so deve conter dígitos";
                    return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.local_phone_rounded,
                      color: Colors.black,
                    ),
                    labelText: 'Telefone',
                    hintText: '(DDD)999999999',
                  ),
                  onSaved: (value) => _formData['phoneNumber'] = value,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = new RegExp(pattern);
                    if (value!.length == 0)
                      return "Informe o Email";
                    else if (!regExp.hasMatch(value))
                      return "Email inválido";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.attach_email,
                      color: Colors.black,
                    ),
                    labelText: 'Email',
                    hintText: 'nome@example.com',
                  ),
                  onSaved: (value) => _formData['email'] = value,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'campo obrigatório';
                    else if (value.length < 6)
                      return 'menor que 6 dígitos';
                    else if (value != _formData['confirmPassword'])
                      return 'senhas não coincidem';
                    return null;
                  },
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.black),
                      labelText: 'Senha',
                      suffixIcon: GestureDetector(
                        child: Icon(
                            _showPassword == false
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black),
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      )),
                  obscureText: _showPassword == false ? true : false,
                  onSaved: (value) => _formData['password'] = value,
                  onChanged: (value) => _formData['password'] = value,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.black),
                      labelText: 'Confirmar senha',
                      suffixIcon: GestureDetector(
                        child: Icon(
                            _showPasswordConfirmation == false
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black),
                        onTap: () {
                          setState(() {
                            _showPasswordConfirmation =
                                !_showPasswordConfirmation;
                          });
                        },
                      )),
                  obscureText:
                      _showPasswordConfirmation == false ? true : false,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'campo obrigatório';
                    else if (value.length < 6)
                      return 'menor que 6 dígitos';
                    else if (_formData['password'] != value)
                      return 'senhas não coincidem';
                    return null;
                  },
                  onSaved: (value) => _formData['confirmPassword'] = value,
                  onChanged: (value) => _formData['confirmPassword'] = value,
                ),
                SizedBox(height: 10),
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
                                primary: Colors.white,
                                backgroundColor: Colors.green,
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              child: Text("Enviar para email"),
                              onPressed: _submitForm))
              ])),
        ));
  }
}

