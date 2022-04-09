import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/shared/config.dart';
import 'package:app_visibility/routes/routes.dart';
import 'package:app_visibility/models/categories.dart';
import 'package:app_visibility/models/accessibility.dart';
import 'package:app_visibility/models/place_types.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:app_visibility/models/evaluation_types.dart';
import 'package:app_visibility/models/information_amount.dart';
import 'package:app_visibility/widgets/pieChart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Informations extends StatefulWidget {

  @override
  _InformationsState createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  FlutterSecureStorage storage = new FlutterSecureStorage();
  AppRoutes appRoutes = new AppRoutes();
  InformationAmount? _informations;
  Categories? _categories;
  Accessibility? _accessibility;
  PlaceTypes? _placeTypes;
  Evaluation? _evaluationTypes;
  int? _nextLevelPoints;
  int? _evaluations;
  int? _points;
  int? _level;
  List<ChartData>? _chartData;
  String? _chartType;
  bool _openDialog = false;
  List<Map<String, dynamic>>? _fatherItems;
  Dio dio = new Dio();
  final i = 10;
  final n = 10;

  // List<Map<String, dynamic>> _items = List.generate(
  //     10,
  //     (index) => {
  //           'index': index,
  //           'sectionTitle': 'Quantidade de Tipos de Avaliações',
  //           'chartTitle': 'Tipo de Avaliações',
  //           'chartData': _evaluationTypes,
  //           'isExpanded': false
  //         });

  getInformationsAmount() async {
    Map<String, String> userData = await storage.readAll();

    Response response = await dio.get(
        '${Config.baseUrl}/users/${userData['id'] as String}/informationAmount',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userData['token']}',
          },
        ));

    this._nextLevelPoints = response.data['nextLevelPoints'];
    this._level = response.data['level'];
    this._points = response.data['points'];
    this._evaluations = response.data['evaluations'];

    InformationAmount informationsAmount =
        InformationAmount.fromJson(response.data);

    Categories categories = Categories.fromJson(response.data);

    Accessibility acessibilidadeLocais = Accessibility.fromJson(response.data);

    PlaceTypes placetypes = PlaceTypes.fromJson(response.data);

    Evaluation evaluations = Evaluation.fromJson(response.data);

    _fatherItems = [
      {
        'index': 0,
        'title': 'Dados Gerais',
        'isExpanded': false,
        'childItems': [
          {
            'title': 'Tipos de Avaliações', // Incluir Total
            'chartData': evaluations, //this._evaluationTypes,
            'statusData': _getListingStatus,
          }
        ]
      },
      {
        'index': 1,
        'title': 'Avaliações de Locais',
        'isExpanded': false,
        'childItems': [
          {
            'title': 'Tipos de Espaços', // Locais
            'chartData': placetypes, // this._placeTypes,
            'statusData': _getListingStatus,
          },
          {
            'title': 'Nível de Acessibilidade', // Locais
            'chartData': acessibilidadeLocais, //this._accessibility,
            'statusData': _getListingStatus,
          },
          {
            'title': 'Categorias', // Locais
            'chartData': categories, //this._categories,
            'statusData': _getListingStatus,
          }
        ]
      },
    ];

    setState(() {
      _informations = informationsAmount;
      _categories = categories;
      _accessibility = acessibilidadeLocais;
      _evaluationTypes = evaluations;
      _placeTypes = placetypes;
    });
  }

  List<Widget> _getListingStatus(classData) {
    List<Widget> widgets = [];

    Map<String, String> mapNames = {
      "accessiblePlace": "Acessível",
      "notAccessiblePlace": "Não Acessível",
      "partiallyAccessiblePlace": "Parcialmente acessível",
      "evaluations": "Avaliações",
      "publicEvaluations": "Locais Públicos",
      "privateEvaluations": "Locais Privados",
      "place": "Locais",
      "wheelchairParking": "Vagas para Cadeirantes",
      "travel": "Viagem",
      "transport": "Transporte",
      "supermarket": "Supermercado",
      "services": "Serviços",
      "leisure": "Lazer",
      "education": "Educação",
      "food": "Alimentação",
      "hospital": "Hospital",
      "accomodation": "Hospedagem",
      "finance": "Financias",
    };

    final dataJson = classData?.toJson();

    for (final data in dataJson!.entries) {
      widgets.add(
        Container(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          alignment: FractionalOffset.center,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(mapNames[data.key.toString()]!,
                  style: new TextStyle(color: Colors.black)),
              new Text(
                data.value.toString(),
                style: new TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    getInformationsAmount();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            // minHeight: viewportConstraints.maxHeight,
            ),
        child: Column(
          children: [
            if (_informations == null)
              Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    value: null,
                  ),
                ),
              )
            else ...[
              Container(
                child: Text(
                  '1',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 60),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.yellow[700]),
                margin:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                padding: EdgeInsets.all(45.0),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                    child: IconButton(
                        icon: Icon(Icons.people_alt),
                        onPressed: () => {
                          setState((){
                            // controller.index = 1;
                          })
                        }),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.yellow[700])),
                Container(
                    child: IconButton(
                        icon: Icon(Icons.emoji_events),
                        onPressed: () => {
                          setState((){
                            // controller.index = 1;
                          })
                        }),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.yellow[700])),
              ]),
              SizedBox(
                height: 50,
              ),
              new LinearPercentIndicator(
                  center: Text(
                    '${_points!} pontos',
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
                  percent: (_points! * 100 / _nextLevelPoints!) / 100,
                  progressColor: Colors.green),
              Container(
                alignment: FractionalOffset.center,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new TextButton(
                      onPressed: () {},
                      child: new Text('Nível ${_level!}',
                          style: new TextStyle(color: Color(0xFF2E3233))),
                    ),
                    new TextButton(
                      child: new Text(
                        '${_points!}/${_nextLevelPoints!}',
                        style: new TextStyle(
                            color: Color(0xFF84A2AF),
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ExpansionPanelList(
                elevation: 3,
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    _fatherItems![index]['isExpanded'] = !isExpanded;
                  });
                },
                animationDuration: Duration(milliseconds: 600),
                children: _fatherItems!
                    .map(
                      (fatherItem) => ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: fatherItem['isExpanded'] == true
                            ? Colors.grey[200]
                            : Colors.white,
                        headerBuilder: (_, isExpanded) => Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            child: Text(
                              fatherItem['title'],
                              style: TextStyle(fontSize: 20),
                            )),
                        body: Wrap(
                        children: [
                          for(final childItem in fatherItem['childItems'])
                            ...[
                              Wrap(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, bottom: 20.0),
                                      margin: const EdgeInsets.only(left: 10.0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            childItem['title'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.insert_chart),
                                              onPressed: () {
                                                setState(() {
                                                  this._openDialog = true;
                                                });

                                                List<ChartData> chartData =
                                                    ChartData.generateChartData(
                                                        childItem['chartData']
                                                            .toJson());

                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            childItem['title']),
                                                        content: Container(
                                                          width: 400,
                                                          height: 350,
                                                          child: Chart()
                                                              .generateChart(
                                                                  chartData),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("Ok"),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    });
                                              })
                                        ],
                                      ),
                                    ),
                                    ...childItem['statusData'](
                                        childItem['chartData']),
                                  ],
                                )
                            ]     
                        ]
                        ),
                        isExpanded: fatherItem['isExpanded'],
                      ),
                    )
                    .toList(),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
