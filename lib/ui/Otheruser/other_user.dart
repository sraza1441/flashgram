import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:techstagram/services/database.dart';
import 'package:techstagram/ui/Otheruser/other_aboutuser.dart';

class OtherUserProfile extends StatefulWidget{
  
  final String uid;
  final String displayNamecurrentUser;
  final String displayName;
  
  OtherUserProfile({this.uid,this.displayNamecurrentUser,this.displayName});
  @override
  _OtherUserProfileState createState() => _OtherUserProfileState(uid: uid,displayNamecurrentUser: displayNamecurrentUser,displayName: displayName);
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  final String uid;
  final String displayNamecurrentUser;
  final String displayName;
  _OtherUserProfileState({this.uid,this.displayNamecurrentUser,this.displayName});

  bool followed = false;

  @override
  void initState() {
    getFollowers();
    // TODO: implement initState
    super.initState();
  }

  getFollowers() {

    Firestore.instance.collection('users')
        .document(uid)
        .collection('followers')
        .document(displayNamecurrentUser)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          followed = true;
          print(followed);
        });
      }
      else{
        setState(() {
          followed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(uid);

    Stream userQuery;

     userQuery = Firestore.instance.collection('users')
        .where('uid', isEqualTo: uid)
        .snapshots();

     String displayNameX = displayName;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(displayNameX),
      ),
      body: StreamBuilder(
      stream: userQuery,
    builder: (context, snapshot) {
    return snapshot.hasData
    ?
    ListView.builder(
    itemCount: snapshot.data.documents.length,
    itemBuilder: (context, index) {
      DocumentSnapshot sd = snapshot.data.documents[index];
      String photoUrl = snapshot.data.documents[index]["photoUrl"];
      String uid = snapshot.data.documents[index]["uid"];
      String displayName = snapshot.data.documents[index]["displayName"];
      String bio = snapshot.data.documents[index]["bio"];
      int followers = snapshot.data.documents[index]["followers"];
      int following = snapshot.data.documents[index]["following"];
      int posts = snapshot.data.documents[index]["posts"];
      return (uid != null) ?
      SingleChildScrollView(
        child: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 180.0),
                      child: Column(
                        children: [
                          Container(
                            height: 300.0,
                            width: 340.0,
                            child: Card(
                              elevation: 5.0,
                              color: Colors.white,
                              // margin: EdgeInsets.only(top:200, bottom: 70,left: 20,right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      displayName,
                                      style: TextStyle(
                                        fontSize: 26.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Pacifico',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: (bio!=null)?Text(
                                      bio,
                                      style: TextStyle(
                                        fontFamily: 'Source Sans Pro',
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                        letterSpacing: 2.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ):Text(""),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    width: 200,
                                    child: Divider(
                                      color: Colors.teal.shade700,
                                    ),
                                  ),
                                  Container(
                                    height: 60.0,
                                    margin: EdgeInsets.only(top: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: <Widget>[
                                        _buildStatItem("FOLLOWERS",
                                            followers.toString()),
                                        _buildStatItem("POSTS", posts.toString()),
                                        _buildStatItem("FOLLOWING",
                                            following.toString()),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: [
                                              (followed == false)?SizedBox(
                                                width: 120,
                                                child: RaisedButton(
                                                    color: Colors.white,
                                                    child: new Text(
                                                      "Follow",
                                                      style: TextStyle(
                                                        color: Color(
                                                            0xffed1e79),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        followed = true;
                                                      });
                                                   DatabaseService().followUser(followers, uid, displayNamecurrentUser);
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Color(
                                                              0xffed1e79),
                                                          width: 2),
                                                      borderRadius: BorderRadius
                                                          .circular(30.0),
                                                    )),
                                              ): SizedBox(
                                                width: 120,
                                                child: RaisedButton(
                                                    color: Colors.white,
                                                    child: new Text(
                                                      "Unfollow",
                                                      style: TextStyle(
                                                        color: Color(
                                                            0xffed1e79),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        followed = false;
                                                      });
                                                      DatabaseService().unfollowUser(followers, uid, displayNamecurrentUser);
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Color(
                                                              0xffed1e79),
                                                          width: 2),
                                                      borderRadius: BorderRadius
                                                          .circular(30.0),
                                                    )),
                                              ),


                                              SizedBox(
                                                width: 120,
                                                child: RaisedButton(

                                                    color: Colors.white,
                                                    child: new Text(
                                                      "Message",
                                                      style: TextStyle(
                                                        color: Color(
                                                            0xffed1e79),
                                                      ),
                                                    ),
                                                    onPressed: () {
//                                                      Navigator.push(
//                                                        context,
//                                                        MaterialPageRoute(
//                                                            builder: (
//                                                                context) =>
//                                                                ProfileSettings()),
//                                                      );
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Color(
                                                              0xffed1e79),
                                                          width: 2),
                                                      borderRadius: BorderRadius
                                                          .circular(30.0),
                                                    )),
                                              ),
                                            ]
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: RaisedButton(
                                              color: Color(0xffed1e79),
                                              child: new Text(
                                                "About",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                               Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => AboutOtherUser(uid: uid,displayNamecurrentUser: displayNamecurrentUser,displayName: displayName)),
                                                );
                                              },
                                              shape: RoundedRectangleBorder(
                                                //side: BorderSide(color: Colors.white, width: 2),
                                                borderRadius: BorderRadius
                                                    .circular(30.0),
                                              )),
                                        )
                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  (photoUrl!=null)?Padding(
                    padding: const EdgeInsets.only(
                        top: 110, left: 145.0, right: 130.0),
                    child:CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(photoUrl),

                      backgroundColor: Colors.transparent,
                    ),
                  ):Padding(
                    padding: const EdgeInsets.only(
                        top: 70, left: 100.0,right: 100.0),
                    child: CircleAvatar(
                      radius: 50,
                      child: IconButton(icon:
                      Icon(FontAwesomeIcons.userCircle,
                        color: Colors.deepPurple,
                        size: 100.0,), onPressed: null),
                      backgroundColor: Colors.white60,
                    ),
                  ),
                ],
            ),
          ),
        ),
      ) : Container();
    },
    ):Container();
    },
      ),
    );
  }
}

Widget _buildStatItem(String label, String count) {
  TextStyle _statLabelTextStyle = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.grey,
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
  );

  TextStyle _statCountTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        label,
        style: _statLabelTextStyle,
      ),
      Text(
        count,
        style: _statCountTextStyle,
      ),

    ],
  );
}