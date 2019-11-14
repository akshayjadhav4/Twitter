import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'EditTweet.dart';
import '../model/Tweet.dart';

class ViewTweet extends StatefulWidget {
  final String id, userUid;
  ViewTweet(this.id, this.userUid);
  @override
  _ViewTweetState createState() => _ViewTweetState(id, userUid);
}

class _ViewTweetState extends State<ViewTweet> {
  String id, userUid;
  _ViewTweetState(this.id, this.userUid);

  Tweet _tweet;
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('Tweets');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  bool isLoading = true;
  bool isUserLoading = true;
  getTweet(id, userUid) async {
    databaseReference.child(userUid).child(id).onValue.listen((event) {
      setState(() {
        _tweet = Tweet.fromSnapshot(event.snapshot);
        isLoading = false;
      });
    });
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser
        ?.reload(); //ISSUE afyer login user info fetched is null hence do reload
    firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isUserLoading = false;
      });
    }
    // print(this.user);
  }

  deleteTweet() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("Are you sure?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancle"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await databaseReference.child(userUid).child(id).remove();
                  navigateToLastScreen();
                },
              )
            ],
          );
        });
  }

  navigateToEditScreen(id, userUid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditTweet();
    }));
  }

  navigateToLastScreen() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUser();
    this.getTweet(id, userUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tweet"),
        actions: <Widget>[
          IconButton(
            tooltip: "Delete",
            onPressed: () {
              deleteTweet();
            },
            icon: Icon(Icons.delete),
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: isUserLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              height: 50.0,
                              child: Image(
                                image: AssetImage("images/logo.png"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${user.displayName}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${user.email}",
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider(
                          height: 30.0,
                        ),
                        Text(
                          "${_tweet.tweet}",
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.left,
                        ),
                        _tweet.photoUrl != 'empty'
                            ? Container(
                                height: 250.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(_tweet.photoUrl),
                                    )),
                              )
                            : Divider(
                                height: 30.0,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.mode_comment,
                              color: Colors.blueGrey,
                              size: 35.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.repeat,
                                    color: Colors.blueGrey,
                                    size: 35.0,
                                  ),
                                  SizedBox(
                                    width: 1.0,
                                  ),
                                  Text(
                                    "500",
                                    style: TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.favorite_border,
                                    color: Colors.blueGrey,
                                    size: 35.0,
                                  ),
                                  SizedBox(
                                    width: 1.0,
                                  ),
                                  Text(
                                    "5000",
                                    style: TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.share,
                              color: Colors.blueGrey,
                              size: 35.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
    );
  }
}
