import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_visibility/shared/config.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:app_visibility/models/get_comments.dart';
import 'package:app_visibility/models/insert_comment.dart';
import 'package:flutter/material.dart';
import 'package:app_visibility/views/achievement_view.dart';
import 'package:app_visibility/utils/notification_service.dart';
import 'package:dio/dio.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List<GetComments>? _comments = [];
  int? _markerId;
  Map<String, dynamic>? _userData;
  bool _isLoad = true;
  Dio dio = new Dio();
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  FlutterSecureStorage storage = new FlutterSecureStorage();

  insertComment(InsertComment comment) async {
    String url = '${Config.baseUrl}/markers/comments';
    final response = await dio.post(url,
        data: comment.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_userData!['token']}',
          },
        ));

    return response;
  }

  loadComments() async {
    Map<String, dynamic> userData = await storage.readAll();

    print(userData);

    String url = '${Config.baseUrl}/markers/${this._markerId}/comments';
    final response = await dio.get(url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${userData['token']}',
          },
        ));

    final commentsJson = response.data;

    List<GetComments> comments = List<GetComments>.from(
        commentsJson.map((comment) => GetComments.fromJson(comment)));

    setState(() {
      _comments = comments;
       _userData = userData;
       _isLoad = false;
    });

    return response;
  }

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          new ExactAssetImage('assets/profile.png')),
                ),
              ),
              title: Text(
                data[i].name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i].message),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map?;

    print(arguments);

    if (arguments != null) {
        this._markerId = arguments['markerId'];
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Comentários"),
        backgroundColor: Colors.yellow[700],
      ),
      body: Container(
        child: (_isLoad == false)
            ? CommentBox(
                userImage:
                    "https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400",
                child: commentChild(_comments),
                labelText: 'Escreva um comentário...',  
                errorText: 'Comment cannot be blank', 
                withBorder: false,
                
                sendButtonMethod: () async {
                  if (formKey.currentState!.validate()) {
                    print(commentController.text);
                    GetComments value = GetComments(
                        message: commentController.text, name: _userData!['name']);

                    setState(() {
                      _comments?.insert(0, value);
                      print(commentController.text);
                    });

                    InsertComment comment = InsertComment(
                      description: commentController.text,
                      userId: int.parse(_userData!['id']),
                      markerId: this._markerId,
                    );

                    await insertComment(comment);

                    Map<String, dynamic> userData = await storage.readAll();
                    String urlUpdateInformationsAmount = '${Config.baseUrl}/users/${userData['id']}/informationAmount';
                    
                    print(urlUpdateInformationsAmount);

                    final informationAmount = await dio.patch(urlUpdateInformationsAmount, data: <String, dynamic>{ 
                        "updatedProperties": ['comments'],
                        "currentAction": "C"
                        },
                          options: Options(
                            headers: {
                              'Authorization': 'Bearer ${userData['token']}',
                            },
                      ));

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Comentário adicionado com sucesso! (+5 pontos)' ), 
                    duration: Duration(seconds: 2),
                    ));

                    commentController.clear();
                    FocusScope.of(context).unfocus();

                    final achievements = informationAmount.data[1] as List<dynamic>;
                    print(achievements);

                    NotificationService n =  NotificationService();
                    int counter = 0;                  
                    await n.initState();

                    if(informationAmount.data[0]['updatedLevel'] == true){
                      await n.showNotification(counter, 'Avançou de nível!', 'Parabéns! você atingiu o nível ${informationAmount.data[0]['level']}', 'O pai é brabo mesmo', true);
                      counter += 1;
                    }
                    if(achievements.length >= 1){
                      for(Map<String, dynamic> achievement in achievements){
                        await n.showNotification(counter, 'Adquiriu uma conquista!', achievement['description'], 'O pai é brabo mesmo', false);
                        counter += 1;
                      }
                    }
                  } else {
                    print("Not validated");
                  }
                },
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                sendWidget:
                    Icon(Icons.send_sharp, size: 30, color: Colors.white),
              )
            : Padding(
                padding: const EdgeInsets.all(180.0),
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      value: null,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
