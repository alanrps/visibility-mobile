import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart {
  SfCircularChart generateChart(chartData) {
    return SfCircularChart(
        legend: Legend(isVisible: true),
        annotations: [],
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
              dataLabelSettings: DataLabelSettings(
                  isVisible: true),
              dataSource: chartData,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y)
        ]);
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final int y;
  final Color? color;

  static List<ChartData> generateChartData(Map<String, dynamic> chartData){
    List<ChartData> chartDataList = [];
    
    for(final data in chartData.entries){
      print(data.key);
      print(data.value);
      chartDataList.add(ChartData(data.key, data.value));
    }

    return chartDataList;
}}