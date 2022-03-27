import 'package:flutter/material.dart';

class Scoreboard extends StatefulWidget {
  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Ranking Contribuidores',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('Nome'),
              subtitle: Text('Posição'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {},
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('Nome'),
              subtitle: Text('Posição'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {},
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('Nome'),
              subtitle: Text('Posição'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => {},
            ),
          ),
                ],
              )),
    );
  }
}

// class NewWidget extends StatelessWidget {
//   const NewWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text("Scoreboard"),
//     );
//   }
// }
