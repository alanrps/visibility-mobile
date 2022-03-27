import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Informations extends StatefulWidget {
  @override
  _InformationsState createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  final i = 10;
  final n = 10;

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              TextButton(
                  onPressed: () => {},
                  // color: Colors.orange,
                  // padding: EdgeInsets.all(10.0),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Image.asset('assets/logo-yellow.png'),
                      Text("Add")
                    ],
                  )),
            ],
          )));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            '1',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 60),
          ),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.yellow[700]),
          margin: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
          padding: EdgeInsets.all(45.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(child: IconButton(icon: Icon(Icons.people_alt), onPressed: () {}), decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.yellow[700])),
            IconButton(icon: Icon(Icons.emoji_events), onPressed: () {}),
          ]
        ),
        // Text(
        //   '4000 pontos',
        //   style: TextStyle(
        //       fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        // ),
        SizedBox(
          height: 20,
        ),
        new LinearPercentIndicator(
            center: Text(
              '50 pontos',
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12),
            ),
            barRadius: Radius.circular(10),
            alignment: MainAxisAlignment.center,
            width: 380,
            lineHeight: 20.0,
            percent: 0.5,
            progressColor: Colors.green),
        Container(
          alignment: FractionalOffset.center,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new TextButton(
                onPressed: () {},
                child: new Text('Nível 1',
                    style: new TextStyle(color: Color(0xFF2E3233))),
              ),
              new TextButton(
                child: new Text(
                  '50/100',
                  style: new TextStyle(
                      color: Color(0xFF84A2AF), fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // FloatingActionButton.extended(
        //   label: Text(
        //     'Visualizar Ranking',
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 14,
        //     ),
        //   ),
        //   enableFeedback: true,
        //   backgroundColor: Colors.grey[400],
        //   icon: Icon(
        //     Icons.emoji_events,
        //     color: Colors.white,
        //     size: 18.0,
        //   ),
        //   onPressed: () {},
        // ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Status das Contribuições',

                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: FractionalOffset.center,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new TextButton(
                    onPressed: () {},
                    child: new Text('Avaliações',
                        style: new TextStyle(color: Color(0xFF2E3233))),
                  ),
                  new TextButton(
                    child: new Text(
                      '10',
                      style: new TextStyle(
                          color: Color(0xFF84A2AF),
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            Container(
              alignment: FractionalOffset.center,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new TextButton(
                    onPressed: () {},
                    child: new Text('Lugares',
                        style: new TextStyle(color: Color(0xFF2E3233))),
                  ),
                  new TextButton(
                    child: new Text(
                      '15',
                      style: new TextStyle(
                          color: Color(0xFF84A2AF),
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            Container(
              alignment: FractionalOffset.center,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new TextButton(
                    onPressed: () {},
                    child: new Text('Lugares',
                        style: new TextStyle(color: Color(0xFF2E3233))),
                  ),
                  new TextButton(
                    child: new Text(
                      '15',
                      style: new TextStyle(
                          color: Color(0xFF84A2AF),
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            Container(
              alignment: FractionalOffset.center,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new TextButton(
                    onPressed: () {},
                    child: new Text('Lugares',
                        style: new TextStyle(color: Color(0xFF2E3233))),
                  ),
                  new TextButton(
                    child: new Text(
                      '15',
                      style: new TextStyle(
                          color: Color(0xFF84A2AF),
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                n,
                (i) => Container(
                  child: Ink(
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      iconSize: 80,
                      icon: Image.asset('assets/icone.png'),
                      color: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                ),
              )),
        )
      ],
    );
  }
}
