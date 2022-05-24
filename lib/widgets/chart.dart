import 'package:flutter/material.dart';
import 'package:app_visibility/widgets/pieChart.dart';


class InformationsChart extends StatefulWidget {
  const InformationsChart({ Key? key }) : super(key: key);

  @override
  State<InformationsChart> createState() => _InformationsChartState();
}

class _InformationsChartState extends State<InformationsChart> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    final chart = arguments!['chartData'];
    bool hasValues = true;

    return Scaffold(
      appBar: AppBar(
          title: Text('Selecione a Localização'),
          backgroundColor: Colors.yellow[700],
        ),
        body: Container(
        child: hasValues ? Chart().generateChart(chart) : Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text('Ainda não há dados para exibir.')
        ],),
      ), 
    );
  }
}