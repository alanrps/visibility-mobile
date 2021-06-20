import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  Gender _userGender = Gender.male;
  bool _showPassword = false, _showPasswordConfirmation = false;

  final ButtonStyle style = ElevatedButton.styleFrom(
    padding: EdgeInsets.all(24),
    primary: Colors.lightGreen[700],
    onPrimary: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );

  void _submitForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      
      String tempPhone = _formData['phone'].toString().trim();
      print(tempPhone);

      final user = new User(
        name: _formData['name'],
        gender: _userGender,
        birthDate: null,
        phone: _formData['phone'],
        email: _formData['email'],
        password: _formData['password'],
      );

      print(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criar conta'),
          backgroundColor: Colors.yellow[700],
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
              key: _form,
              child: ListView(children: <Widget>[
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
                          foreground: Paint()..color = Colors.grey[600],
                        ),
                      )
                    ]),
                    ListTile(
                      title: const Text('Homem'),
                      leading: Radio<Gender>(
                        value: Gender.male,
                        groupValue: _userGender,
                        onChanged: (Gender value) {
                          setState(() {
                            _userGender = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Mulher'),
                      leading: Radio<Gender>(
                        value: Gender.female,
                        groupValue: _userGender,
                        onChanged: (Gender value) {
                          setState(() {
                            _userGender = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Outro'),
                      leading: Radio<Gender>(
                        value: Gender.outro,
                        groupValue: _userGender,
                        onChanged: (Gender value) {
                          setState(() {
                            _userGender = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    String patttern = r'(^[0-9]*$)';
                    RegExp regExp = new RegExp(patttern);
                    if (value.length == 0)
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
                  onSaved: (value) => _formData['phone'] = value,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    String pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = new RegExp(pattern);
                    if (value.length == 0)
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
                new Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                        style: style,
                        child: Text("Cadastrar"),
                        onPressed: _submitForm)),
              ])),
        ));
  }
}
