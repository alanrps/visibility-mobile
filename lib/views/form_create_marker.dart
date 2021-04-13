import 'package:app_visibility/views/home.dart';
import 'package:flutter/material.dart';

class FormCreateMark extends StatefulWidget {
  @override
  _FormCreateMark createState() => _FormCreateMark();
}

class _FormCreateMark extends State<FormCreateMark> {
  // final _titleController = TextEditingController();

  void _submitForm() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Marcação'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Home(),
                ],
              ),
            ),
          ),
          TextButton.icon(
            icon: Icon(Icons.add),
            label: Text('Adicionar'),
            style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Theme.of(context).accentColor,
              elevation: 0,
              // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _submitForm,
          ),
        ],
      ),
    );
  }
}
