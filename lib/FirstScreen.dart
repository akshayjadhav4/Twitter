import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  navigateToSignUpScreen() {
    Navigator.pushReplacementNamed(context, '/SignUpPage');
  }

  navigateToSignInScreen() {
    Navigator.pushReplacementNamed(context, '/SignInPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 2.0),
              child: Image(
                image: AssetImage("images/twitter.png"),
                width: 70.0,
                height: 70.0,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Text(
                "See what's happening in \n the world right now",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Text(
                "Join Twitter today.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              width: double.infinity,
              child: RaisedButton(
                onPressed: navigateToSignUpScreen,
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),

              width: double.infinity, // to make widget equal to parent widget
              child: OutlineButton(
                onPressed: navigateToSignInScreen,
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20.0, color: Colors.blue),
                ),
                borderSide: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 0.0),
                child:Container(
                  color: Colors.lightBlue,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search,color: Colors.white,size: 25.0,),
                            SizedBox(width: 10.0,),
                            Text("Follow your interests.",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.people_outline,color: Colors.white,size: 25.0,),
                            SizedBox(width: 10.0,),
                            Text("Hear what people are talking about.",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.chat_bubble_outline,color: Colors.white,size: 25.0,),
                            SizedBox(width: 10.0,),
                            Text("Join the conversation.",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),
          )
          ],
        ),
      ),
    );
  }
}
