import 'package:firebase_database/firebase_database.dart';

class Tweet {
  String _id;
  String _tweet;
  String _photoUrl;

  //Constructor for add tweet
  Tweet(this._tweet,this._photoUrl);

  //Constructor for edit tweet
  Tweet.withId(this._id,this._tweet,this._photoUrl);

  //getters
  String get id => this._id;
  String get tweet => this._tweet;
  String get photoUrl => this._photoUrl;

  //setters
  set tweet(String tweet){
    this._tweet = tweet;
  }

  set photoUrl(String photoUrl){
    this._photoUrl = photoUrl;
  }

  //Convert Firebase snapshot to Tweet object
  Tweet.fromSnapshot(DataSnapshot snapshot){
    this._id = snapshot.key;
    this._tweet = snapshot.value['tweet'];
    this._photoUrl = snapshot.value['photoUrl'];
  }



   Map<String ,dynamic> toJson(){
     return{
       'tweet':_tweet,
       'photoUrl':_photoUrl
     };
   }

}