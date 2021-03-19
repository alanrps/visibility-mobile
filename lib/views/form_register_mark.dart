import 'package:app_visibility/widgets/location_input.dart';
import 'package:flutter/material.dart';

class FormRegisterMark extends StatefulWidget {
  @override
  _FormRegisterMark createState() => _FormRegisterMark();
}

class _FormRegisterMark extends State<FormRegisterMark> {
  final _titleController = TextEditingController();

  void _submitForm() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Marcação'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  MyLocation(),
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
