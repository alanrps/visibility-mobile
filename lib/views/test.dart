import 'package:flutter/material.dart';

class Teste extends StatefulWidget {
  const Teste({ Key? key }) : super(key: key);

  @override
  State<Teste> createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("AOOOOBA"),
    );
  }
}