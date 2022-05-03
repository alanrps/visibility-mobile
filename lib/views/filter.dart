// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:app_visibility/routes/routes.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppRoutes appRoutes = new AppRoutes();

  Map<String, String> _categories = {
    "TRAVEL": "Viagem",
    "TRANSPORT": "Transporte",
    "SUPERMARKET": "Supermercado",
    "SERVICES": "Serviços",
    "LEISURE": "Lazer",
    "EDUCATION": "Educação",
    "FOOD": "Comida",
    "HOSPITAL": "Hospital",
    "ACCOMODATION": "Alojamentos",
    "FINANCE": "Financias",
  };

  Map<String, String> _accessibilities = {
    "ACCESSIBLE": "Acessível",
    "NOT ACCESSIBLE": "Não acessível",
    "PARTIALLY": "Parcialmente",
  };

  List<Object?> _accessibilitiesInitialValue = [];
  List<Object?> _categoriesInitialValue = [];
  List<MultiSelectItem> _listAcessibilities = [];
  List<MultiSelectItem> _listCategories = [];
  List<Object?> _selectedCategories = [];
  List<Object?> _selectedAccessibilities = [];
  List<MultiSelectItem> _itemsAccessibilities = [];
  List<MultiSelectItem> _itemsCategories = [];
  
  void mapItems() {
    List<MultiSelectItem> categories = _categories.entries.map((category) => MultiSelectItem(category.key, category.value)).toList();
    List<MultiSelectItem> acessibilities = _accessibilities.entries.map((acessibility) => MultiSelectItem(acessibility.key, acessibility.value)).toList();

    setState(() {
      _listCategories = categories;
      _listAcessibilities = acessibilities;
    });
  }

  @override
  void initState() {
    mapItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    print(arguments);

    if(arguments!["acessibilities"] != null && _selectedAccessibilities.length == 0){
      print("ARGUMENTOS ACESSIBILIDADE");
      _accessibilitiesInitialValue = arguments["acessibilities"] as List<Object?>;
      _selectedAccessibilities = arguments["acessibilities"] as List<Object?>;
      _itemsAccessibilities = _selectedAccessibilities.map((acessibility) => MultiSelectItem(acessibility, _accessibilities[acessibility]!)).toList();
    }
    if(arguments["categories"] != null && _selectedCategories.length == 0){
      print("ARGUMENTOS CATEGORIAS");
      _categoriesInitialValue = arguments["categories"] as List<Object?>;
      _selectedCategories = arguments["categories"] as List<Object?>;
      _itemsAccessibilities = _selectedCategories.map((category) => MultiSelectItem(category, _categories[category]!)).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text("Filtragem de Dados"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    MultiSelectBottomSheetField(
                      selectedColor: Colors.blue[300],
                      initialChildSize: 0.4,
                      listType: MultiSelectListType.LIST,
                      // colorator: (object) {
                      //   return Colors.blue;
                      // },
                      searchable: true,
                      initialValue: _categoriesInitialValue,
                      buttonText: Text("Categorias"),
                      title: Text("Categorias"),
                      items: _listCategories,
                      // onSelectionChanged: (item){
                      //   print(item);
                      //   _list.remove(item);
                      // },
                      onConfirm: (List<Object?> values) {
                        setState(() {
                          _selectedCategories = values;
                          _itemsCategories = values.map((category) => MultiSelectItem(category, _categories[category]!)).toList();
                        });
                        print(values);
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        // items: _itemsCategories,
                        chipColor: Colors.blue[300],
                        textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        ),
                        // icon: Icon(
                        //   Icons.close,
                        //   color: Colors.black,
                        // ),
                        scroll: true,
                        // onTap: (value) {
                        //   print(value);

                        //   final list = _listCategories.map((element) {
                        //     print(element);
                        //     if (element.value == value) {
                        //       print(element.value);
                        //       element.selected = false;
                        //     }
                        //     return element;
                        //   }).toList();

                        // List<MultiSelectItem<dynamic>> listCategories = _listAcessibilities.fold(<MultiSelectItem<dynamic>>[], (List<MultiSelectItem<dynamic>> acc, MultiSelectItem<dynamic> element){
                        //   if(element.value != value)
                        //     acc.add(element);

                        //   return acc;
                        // });

                        //   setState(() {
                        //     _selectedCategories.remove(value);
                        //     _categoriesInitialValue.remove(value);
                        //     _listCategories = list;
                        //     _itemsCategories = listCategories;
                        //   });
                        // },
                      ),
                    ),
                    _selectedCategories == null || _selectedCategories.isEmpty
                        ? Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Nenhuma categoria selecionada",
                              style: TextStyle(color: Colors.black54),
                            ))
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    MultiSelectBottomSheetField(
                      selectedColor: Colors.blue[300],
                      initialChildSize: 0.4,
                      listType: MultiSelectListType.LIST,
                      // colorator: (object) {
                      //   return Colors.blue;
                      // },
                      searchable: true,
                      initialValue: _accessibilitiesInitialValue,
                      buttonText: Text("Acessibilidade"),
                      title: Text("Acessibilidade"),
                      items: _listAcessibilities,
                      // onSelectionChanged: (item){
                      //   print(item);
                      //   _listAcessibilities.remove(item);
                      // },
                      onConfirm: (List<Object?> values) {
                        setState(() {
                          _selectedAccessibilities = values;
                          _itemsAccessibilities = values.map((accessibilities) => MultiSelectItem(accessibilities, _categories[accessibilities]!)).toList();
                        });
                        print(values);
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        items: _itemsAccessibilities,
                        textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        ),
                        // icon: Icon(
                        //   Icons.close,
                        //   color: Colors.black,
                        // ),
                        // decoration: BoxDecoration(
                        //   borderRadius: new BorderRadius.all(Radius.circular(10)),
                        //   border: Border.all(color: Colors.grey[700]!, width: 1.8),
                        // ),
                        scroll: true,
                        // textStyle: TextStyle(
                        // fontSize: 12,
                        // fontWeight: FontWeight.w400,
                        // color: Colors.black,
                        // ),
                        // colorator: (object){
                        //   return Colors.grey[100];
                        // },
                        // onTap: (value) {
                        //   print(value);

                        //   final list = _listAcessibilities.map((element) {
                        //     print(element);
                        //     if (element.value == value) {
                        //       print(element.value);
                        //       element.selected = false;
                        //     }
                        //     return element;
                        //   }).toList();
                          
                        //   List<MultiSelectItem<dynamic>> listAccessibilities = _listAcessibilities.fold(<MultiSelectItem<dynamic>> [], (List<MultiSelectItem<dynamic>> acc, MultiSelectItem<dynamic> element){
                        //   if(element.value != value)
                        //     acc.add(element);

                        //   return acc;
                        //   });

                        //   setState(() {
                        //     _accessibilitiesInitialValue.remove(value);
                        //     _selectedAccessibilities.remove(value);
                        //     _listAcessibilities = list;
                        //     _itemsAccessibilities = listAccessibilities;
                        //   });
                        // },
                      ),
                    ),
                    _selectedAccessibilities == null || _selectedAccessibilities.isEmpty
                        ? Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Nenhum nível de acessibilidade selecionado",
                              style: TextStyle(color: Colors.black54),
                            ))
                        : Container(),
                  ],
                ),
              ),
               Container(
                          padding: EdgeInsets.all(12),
                          child: ElevatedButton(
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                backgroundColor: Colors.yellow[700],
                                // textStyle: TextStyle(
                                //   fontSize: 18,
                                // ),
                              ),
                              child: Text("Filtrar Marcadores"),
                              onPressed: (){
                                Navigator.pop(context, {
                                  "acessibilities": this._selectedAccessibilities,
                                  "categories": this._selectedCategories, 
                                });
                              })
                          ),
            ],
          ),
        ),
      ),
    );
  }
}
