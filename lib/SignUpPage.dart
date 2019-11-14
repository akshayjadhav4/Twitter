import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//1
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  //2 init firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //3 Define Global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //4 Form variables
  String _fullname;
  String _email;
  String _password;

  //5 check Authentication
  checkAuthentication() async{
    _auth.onAuthStateChanged.listen((user){
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  //6
  navigateToSignInScreen(){
    Navigator.pushReplacementNamed(context, '/SignInPage');
  }
  //7
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuthentication();
  }
  
  //9 SignUp method
  signUp() async{
     if (_formKey.currentState.validate()) {
       _formKey.currentState.save();
       try {
         // create user with email and password
         FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email,password: _password)).user;
         if (user != null) {
           //update user info
           _auth.currentUser().then((value){
           UserUpdateInfo updateUser = UserUpdateInfo();
           updateUser.displayName = _fullname;
           value.updateProfile(updateUser);
           });
         }
       } catch (e) {
          showError(e.message);
       }
     }
  }
  //8
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
                "Create your account",
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
                     //name
                    Container(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Provide an Name";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        onSaved: (input) => _fullname = input,
                      ),
                    ),
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
                        onPressed: signUp,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
              
            ),
            GestureDetector(
                onTap: navigateToSignInScreen,
                child: Text("Already have an account!",style: TextStyle(color: Colors.blue),textAlign: TextAlign.center,),
              ),
          ],
        )),
      ),
    );
  }
}