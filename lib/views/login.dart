import 'package:flutter/material.dart';
//routes
import 'package:app_visibility/routes/routes.dart';
// import 'package:app_visibility/views/form_register_mark.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(
              top: 60,
              left: 40,
              right: 40,
            ),
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  width: 40,
                  height: 90,
                  child: Image.asset('assets/logo-yellow.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
                TextFormField(
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: new TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "Senha",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text(
                      "Recuperar Senha",
                      textAlign: TextAlign.right,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                    height: 60,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.3, 1],
                        colors: [
                          Colors.yellow[500],
                          Colors.yellow[900],
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
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRoutes.HOME)),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  color: Colors.white,
                  child: TextButton(
                    child: Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => {},
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 650,
                  height: 160,
                  child: Image.asset(
                    'assets/art-yellow.png',
                  ),
                ),
              ],
            )));
  }
}

// backgroundColor: Colors.white,
//       body: Padding(
//           padding: EdgeInsets.all(15),
//           child: Center(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextFormField(
//                 autofocus: true,
//                 keyboardType: TextInputType.text,
//                 style: new TextStyle(color: Colors.black, fontSize: 20),
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//               ),
//               Divider(),
//               TextFormField(
//                 autofocus: true,
//                 obscureText: true,
//                 keyboardType: TextInputType.text,
//                 style: new TextStyle(color: Colors.black, fontSize: 20),
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   labelStyle: TextStyle(color: Colors.black),
//                 ),
//               ),
//               Divider(),
//               ButtonTheme(
//                 height: 60,
//                 child: RaisedButton(
//                     color: Colors.yellowAccent[400],
//                     onPressed: () => {},
//                     child: Text('Entrar',
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold))),
//               )
//             ],
//           )))
