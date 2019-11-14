import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//1
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/painting.dart';

import 'AddTweet.dart';
import 'EditTweet.dart';
import 'ViewTweet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //2
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Database Reference
  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child("Tweets");

  //3
  FirebaseUser user;
  //4
  bool isSignedIn = false;
  bool isUserIdNull = true;
  //5 check user is login or not
  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/FirstScreen");
      }
    });
  }

  //6 if user login then get user
  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser
        ?.reload(); //ISSUE afyer login user info fetched is null hence do reload
    firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
        this.isUserIdNull = false;
      });
    }
    // print(this.user);
  }

  //7 Signout method
  signOut() async {
    _auth.signOut();
  }

  //8
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  navigateToAddTweet(uid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTweet(uid);
    }));
  }

  //userID and ID is passed
  navigateToViewTweet(id, uid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewTweet(id, uid);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          radius: 2.0,
          child: ClipOval(
            child: SizedBox(
              width: 40.0,
              height: 40.0,
              child: Image(image: AssetImage("images/logo.png")),
            ),
          ),
        ),
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  "${user.displayName}",
                  style: TextStyle(fontSize: 15.0),
                ),
                accountEmail: Text(
                  "${user.email}",
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("images/logo.png"))),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "Profile",
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.list),
                title: Text(
                  "Lists",
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.bookmark_border),
                title: Text(
                  "Bookmarks",
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.flash_on),
                title: Text(
                  "Moments",
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                ),
              ),
            ),
            Divider(
              height: 30.0,
              color: Colors.blueGrey,
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.trending_up),
                title: Text(
                  "Twitter Ads",
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.assignment),
                title: Text(
                  "Analytics",
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                ),
              ),
            ),
            Divider(
              height: 30.0,
              color: Colors.blueGrey,
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  "Settings and privacy",
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.help_outline),
                title: Text(
                  "Help Center",
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                ),
              ),
            ),
            Divider(
              height: 30.0,
              color: Colors.blueGrey,
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.close),
                title: Text(
                  "Logout",
                  style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                ),
                onTap: signOut,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.blue),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.blueGrey,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.mail_outline,
                color: Colors.blueGrey,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Container(
        child: Center(
          child: !isSignedIn && isUserIdNull
              ? CircularProgressIndicator()
              : Container(
                  child: FirebaseAnimatedList(
                  query: _databaseReference.child(user.uid),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return GestureDetector(
                      onTap: () {
                        navigateToViewTweet(snapshot.key, user.uid);
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 1.0,
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          child: Column(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                height: 10.0,
                              ),
                              Text(
                                "${snapshot.value['tweet']}",
                                style: TextStyle(fontSize: 20.0),
                                textAlign: TextAlign.left,
                              ),
                              snapshot.value['photoUrl'] != 'empty'
                                  ? Container(
                                      height: 250.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                snapshot.value['photoUrl']),
                                          )),
                                    )
                                  : Divider(
                                      height: 30.0,
                                    ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          style:
                                              TextStyle(color: Colors.blueGrey),
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
                                          style:
                                              TextStyle(color: Colors.blueGrey),
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
                        ),
                      ),
                    );
                  },
                )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle_outline),
        onPressed: () {
          navigateToAddTweet(user.uid);
        },
      ),
    );
  }
}
