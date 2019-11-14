import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//1 import firebase auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //2 init firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //3 Define Global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //4 Form variables
  String _email;
  String _password;

  //5 to check user login or not
  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  //6 to send user to signup screen
  navigateToSignUpScreen() {
    Navigator.pushReplacementNamed(context, '/SignUpPage');
  }

  //7 as page loads up it check for authentication
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuthentication();
  }

  //9 sign in method
  void signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        AuthResult user = (await _auth.signInWithEmailAndPassword(
            email: _email, password: _password));
      } catch (e) {
        showError(e.message);
      }
    }
  }

  //8 show error method
  showError(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 20.0),
              child: Image(
                image: AssetImage("images/twitter.png"),
                width: 70.0,
                height: 70.0,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Log in to Twitter",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    //email
                    Container(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Provide an Email";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone,email or username',
                        ),
                        onSaved: (input) => _email = input,
                      ),
                    ),
                    //password
                    Container(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (input) {
                          if (input.length < 6) {
                            return "Password should be 6 character";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        onSaved: (input) => _password = input,
                        //To convert text to password
                        obscureText: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15.0),
                      width: 500.0,
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        color: Colors.blue,
                        onPressed: signIn,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          "Log in",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
              
            ),
            GestureDetector(
                onTap: navigateToSignUpScreen,
                child: Text("Sign up for Twitter",style: TextStyle(color: Colors.blue),textAlign: TextAlign.center,),
              ),
          ],
        )),
      ),
    );
  }
}
