import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//1
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import '../model/Tweet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AddTweet extends StatefulWidget {
final  String uid;
  AddTweet(this.uid);
  @override
  _AddTweetState createState() => _AddTweetState(uid);
}

class _AddTweetState extends State<AddTweet> {
   String uid;
  _AddTweetState(this.uid);
  //2
  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child("Tweets");
  //3
  String _tweet = '';
  String _photoUrl = 'empty';

  //4
  saveTweet(BuildContext context) async {
    if (_tweet.isNotEmpty) {
      Tweet tweet = Tweet(this._tweet, this._photoUrl);
      //upload database
      await _databaseReference.child(uid).push().set(tweet.toJson());
      navigateTolastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Filled Required"),
              content: Text("All fields required"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  //5
  navigateTolastScreen(context) {
    Navigator.of(context).pop();
  }

  //6 pick image
  Future pickImage() async {
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery,maxWidth: 300.0,maxHeight: 300.0);
    String fileName = basename(file.path);
    // print("fileName == $file");
    uploadImage(file, fileName);
  }

  //7 Upload Image
  void uploadImage(File file, String fileName) async {
    //Storagr Ref
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(uid).child(fileName);
    //upload
    storageReference.putFile(file).onComplete.then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      print(downloadUrl);
      if (this.mounted) {
          setState(() {
          _photoUrl = downloadUrl;
          print(_photoUrl);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Tweet"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text("Tweet"),
              onPressed: () {
                this.saveTweet(context);
              },
              color: Colors.lightBlueAccent,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Image(image: AssetImage("images/logo.png")),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Container(
                      child: Flexible(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _tweet = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 50.0),
                        labelText: "Whats's happening?",
                      ),
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50.0,
                  ),
                  IconButton(
                    tooltip: "Add Image",
                    onPressed: pickImage,
                    icon: Icon(
                      Icons.photo_library,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(width: 2.0),
                  Icon(
                    Icons.gif,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  SizedBox(width: 2.0),
                  Icon(
                    Icons.poll,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 55.0,
                  ),
                  Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.blueGrey,
                    size: 30.0,
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Colors.blueGrey,
                    size: 30.0,
                  ),
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
