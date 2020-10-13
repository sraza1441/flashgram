import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:techstagram/models/posts.dart';
import 'package:techstagram/models/user.dart';
import 'package:techstagram/resources/auth.dart';
import 'package:techstagram/resources/uploadimage.dart';
import 'package:techstagram/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:techstagram/models/wiggle.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:techstagram/ui/HomePage.dart';
import 'package:techstagram/ui/Otheruser/other_user.dart';
import 'package:techstagram/views/tabs/comments_screen.dart';
//import 'package:techstagram/services/database.dart';
//import 'package:techstagram/ui/Otheruser/other_aboutuser.dart';
//
//import '../../constants3.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'dart:math' as math;


class FeedsPage extends StatefulWidget {
  final displayNamecurrentUser;
  @override

  final Wiggle wiggle;
  final List<Wiggle> wiggles;
  final Timestamp timestamp;
  final String description;
  final String url;
  final String postId;
  final int likes;
  final String uid;

  FeedsPage(
      {this.wiggles,
        this.wiggle,
        this.timestamp,
        this.description,
        this.url,
        this.uid,
        this.postId,
        this.displayNamecurrentUser,
        this.likes});

  @override
  _FeedsPageState createState() => _FeedsPageState(displayNamecurrentUser: displayNamecurrentUser);
}

class _FeedsPageState extends State<FeedsPage> {

  bool isLoading = true;
  bool liked = false;
  bool isEditable = false;
  final String displayNamecurrentUser;

  _FeedsPageState({this.displayNamecurrentUser});
  String loadingMessage = "Loading Profile Data";
  TextEditingController emailController,urlController,descriptionController,
      displayNameController,photoUrlController,
      timestampController,likesController,uidController;
  List<Posts> posts;
  List<DocumentSnapshot> list;

  Map<String, dynamic> _profile;
  bool _loading = false;

  DocumentSnapshot docSnap;
  FirebaseUser currUser;

  ScrollController scrollController = new ScrollController();
  Posts currentpost;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  double _scale = 1.0;
  double _previousScale;
  var yOffset = 400.0;
  var xOffset = 50.0;
  var rotation = 0.0;
  var lastRotation = 0.0;

  @override
  void initState() {

    emailController = TextEditingController();
    likesController = TextEditingController();
    uidController = TextEditingController();
    displayNameController = TextEditingController();
    photoUrlController = TextEditingController();

    super.initState();
    // Subscriptions are created here
    authService.profile.listen((state) => setState(() => _profile = state));

    authService.loading.listen((state) => setState(() => _loading = state));
    fetchPosts();
    fetchProfileData();

//    fetchLikes();

    //print("widget bhaiyya");
    //print(widget.uid);
  }


  Stream<QuerySnapshot> postsStream;
  final timelineReference = Firestore.instance.collection('posts');
  String postIdX;

  fetchPosts() async {

    await DatabaseService().getPosts().then((val){
      setState(() {
        postsStream = val;
      });
    });
  }



  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      // user have just tapped on screen (no dragging)
      return ;

    if (details.primaryVelocity.compareTo(0) == -1) {
//      dispose();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(initialindexg: 3)),
      );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(initialindexg: 1)),
      );
    }
  }


  getlikes( String displayNamecurrent, String postId) async {


    await Firestore.instance.collection('posts')
        .document(postId)
        .collection('likes')
        .document(displayNamecurrentUser)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          liked = true;

        });
      }
    });

  }

//  fetchLikes() async {
//    currUser = await FirebaseAuth.instance.currentUser();
//    try {
//      docSnap = await Firestore.instance
//          .collection("likes")
//          .document(currUser.uid)
//          .get();
//      setState(() {
//        isLoading = false;
//        isEditable = true;
//      });
//    } on PlatformException catch (e) {
//      print("PlatformException in fetching user profile. E  = " + e.message);
//    }
//  }

  fetchProfileData() async {
    currUser = await FirebaseAuth.instance.currentUser();
    try {
      docSnap = await Firestore.instance
          .collection("users")
          .document(currUser.uid)
          .get();
      emailController.text = docSnap.data["email"];
      likesController.text = docSnap.data["likes"];
      uidController.text =  docSnap.data["uid"];
      displayNameController.text = docSnap.data["displayName"];
      photoUrlController.text = docSnap.data["photoURL"];


      setState(() {
        isLoading = false;
        isEditable = true;
      });
    } on PlatformException catch (e) {
      print("PlatformException in fetching user profile. E  = " + e.message);
    }
  }



  var time = "s";
  User currentUser;

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    if (diff.inHours > 0) {
      time = "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }

    else if (diff.inSeconds <= 0) {
      time = "just now";
    }


    else if (diff.inMinutes > 0) {
      time = "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    }



     else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }


  File _image;
  bool upload;
  int likescount;
  bool loading = false;

  Future pickImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
        upload = true;
      });
    });
    (_image!=null)?
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadImage(file: _image,)),
    ):Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(initialindexg: 2,)),
    );
    print("Done..");
  }

  doubletaplike(int likes, String postId) async {
    if(liked = false) {
       await DatabaseService().likepost(
          likes, postId,
          displayNameController.text);
      setState(() {
        liked = true;
        print(liked);
      });
    }else{
      print("ghg");
    }
    // else if (liked = true){
    //   DatabaseService().unlikepost(
    //       likes, postId,
    //       displayNameController.text);
    //   setState(() {
    //     liked = false;
    //     print(liked);
    //   });
    //
    // }
  }
  String urlx;

  TransformationController _controller = TransformationController();



  @override
  Widget build(BuildContext context) {




//    fetchdimensions(String url) async {
//      File image = new File(url);
//      var decodedImage = await decodeImageFromList(image.readAsBytesSync());
//      print(decodedImage.width);
//      print(decodedImage.height);
//    }


    //print(displayNameController.text);

    // TODO: implement build
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) =>
          _onHorizontalDrag(details),
      onTap: () {
        print("hello");
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: StreamBuilder(
          stream: postsStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Column(
              children: [

                new Expanded(
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {

                        postIdX = snapshot.data.documents[index]['email'];
                        String email = snapshot.data.documents[index]['email'];
                        String description =
                        snapshot.data.documents[index]['description'];
                        String displayName =
                        snapshot.data.documents[index]['displayName'];
                        String photoUrl =
                        snapshot.data.documents[index]['photoURL'];
                        String uid = snapshot.data.documents[index]["uid"];

                        Timestamp timestamp =
                        snapshot.data.documents[index]['timestamp'];
                        String url = snapshot.data.documents[index]['url'];
                        String postId = snapshot.data.documents[index]['postId'];
                        int likes = snapshot.data.documents[index]['likes'];
                        int comments = snapshot.data.documents[index]['comments'];
                        likescount = likes;
                        readTimestamp(timestamp.seconds);


                        getlikes(displayNameController.text,postId);
//                        fetchdimensions(url);




                        if(likes == 0){

                          liked = false;
                        }


                        return Container(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                (index == 0)?Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlatButton(
                                        onPressed:
                                            (){
                                          pickImage();
                                          if (upload == true){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => UploadImage(file: _image),));
                                          }else{
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => HomePage(initialindexg: 2,),));
                                          }
                                        },
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Icon(FontAwesomeIcons.plus,color: Colors.deepPurpleAccent,),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Add Post",style:
                                              TextStyle(
                                                color: Colors.deepPurpleAccent,
                                              ),),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 100.0),
                                      // ),
                                      // FlatButton(onPressed: (){},
                                      //   color: Colors.transparent,
                                      //   child: Row(
                                      //     children: [
                                      //       Icon(FontAwesomeIcons.star,color: Colors.deepPurpleAccent,),
                                      //       Padding(
                                      //         padding: const EdgeInsets.all(8.0),
                                      //         child: Text("Rate us",style:
                                      //         TextStyle(
                                      //           color: Colors.deepPurpleAccent,
                                      //         ),),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ): Container(height: 0.0,width: 0.0,),

                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => OtherUserProfile(uid: uid,displayNamecurrentUser: displayNameController.text,displayName: displayName,uidX: uidController.text,)),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(40),

                                              child: Image(
                                                image: NetworkImage(photoUrl),
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(displayName),
                                          ],
                                        ),
                                        IconButton(
                                          icon: Icon(SimpleLineIcons.options),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                                GestureDetector(
                                  onDoubleTap: () async {
//                                    getlikes(displayNameController.text, postId);
                                    if (liked == false) {
                                      await DatabaseService().likepost(
                                          likes, postId,
                                          displayNameController.text);
                                      setState(() {
                                        liked = true;
                                        print(liked);
                                      });
//                                     return liked;
                                    } else {
                                      print("nahi");
                                    }
                                  },
                                  // onPressed: () {
                                  // },
                                  // icon: Icon(FontAwesome.thumbs_up,color: Colors.deepPurple,),

                                  // onDoubleTap: (){
                                  //   print("double tap");
                                  //   print(liked);
                                  //   doubletaplike(likes,postId);
                                  //   print("double tap again");
                                  //   print(liked);
                                  // },
                                  onTap: null,

                                  child: GestureDetector(

                                            child :FadeInImage(

                                              image: NetworkImage(url),
                                              //image: NetworkImage("posts[i].postImage"),
                                              placeholder: AssetImage("assets/images/loading.gif"),
                                              width: MediaQuery.of(context).size.width,



                                            ),
                                        ),
                                ),







                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        (liked == false)?IconButton(
                                          onPressed: () async {
//                                            setState(() {
//                                              loading = true;
//                                              likescount++;
//                                            });

                                            await DatabaseService().likepost(
                                                likes, postId, displayNameController.text);
                                            setState(() {
                                              liked = true;
                                              loading = false;
                                            });
                                          },
                                          icon: Icon(FontAwesomeIcons.thumbsUp),
                                          color: Colors.deepPurple,
                                          // onPressed: () {
                                          // },
                                          // icon: Icon(FontAwesome.thumbs_up,color: Colors.deepPurple,),
                                        ):IconButton(

                                          onPressed: () async {
//                                            setState(() {
//                                              loading = true;
//                                              likescount--;
//                                            });

                                            await DatabaseService().unlikepost(
                                                likes, postId, displayNameController.text);
                                            setState(() {
                                              liked = false;
                                              loading = false;
                                            });
                                          },

                                          icon: Icon(FontAwesomeIcons.solidThumbsUp),

                                          color: Colors.deepPurple,
                                          // onPressed: () {
                                          // },
                                          // icon: Icon(FontAwesome.thumbs_up,color: Colors.deepPurple,),
                                        ),
                                        (loading == false)?Text(
                                          likes.toString(),style: TextStyle(
                                          color: Colors.black,
                                        ),

                                        ):Text(
                                          likescount.toString(),style: TextStyle(
                                          color: Colors.black,
                                        ),

                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 3.0),
                                          child: IconButton(

                                            onPressed: () { //print(displayNameController.text);
                                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                                return CommentsPage(comments: comments,postId: postId, uid: uid, postImageUrl: url,timestamp: timestamp,displayName: displayName,photoUrl: photoUrlController.text,displayNamecurrentUser: displayNameController.text);
                                              }));
                                            },
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: ((context) => CommentsScreen())));

                                            icon: Icon(Icons.insert_comment,color: Colors.deepPurpleAccent),
                                          ),
                                        ),
                                        Text(comments.toString()),
                                        // IconButton(
                                        //   onPressed: () {},
                                        //   icon: Icon(Icons.share,color: Colors.deepPurpleAccent),
                                        // ),
                                      ],
                                    ),
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   icon: Icon(FontAwesome.bookmark_o),
                                    // ),
                                  ],
                                ),

                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: Row(
                                      children: [
                                        Positioned(
                                          top:1.0,
                                          child: Container(
                                            child: RichText(
                                              textAlign: TextAlign.start,
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: displayName + "  ",
                                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
                                                  ),
                                                  TextSpan(
                                                    text: description,
                                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,
                                                        fontSize: 15.0),
                                                  ),
                                                ],
                                              ),

                                            ),
                                          ),
                                        ),

                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 3.0),
                                        //   child: Container(
                                        //
                                        //     constraints: BoxConstraints(maxWidth: 250),
                                        //     child: RichText(
                                        //       textAlign: TextAlign.start,
                                        //       softWrap: true,
                                        //       overflow: TextOverflow.visible,
                                        //       text: TextSpan(
                                        //         text: description,
                                        //         style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,
                                        //             fontSize: 15.0),
                                        //
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    )
                                ),

                                // caption
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 5,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    readTimestamp(timestamp.seconds),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )
                : Container();

          },
        ),
      ),
    );
  }

//  displayComments(BuildContext context, {String postId, String uid, String url,Timestamp timestamp, String displayName, String photoUrl,String displayNamecurrentUser}){
//    Navigator.push(context, MaterialPageRoute(builder: (context){
//    return CommentsPage(postId: postId, uid: uid, postImageUrl: url,timestamp: timestamp,displayName: displayName,photoUrl: photoUrl,displayNamecurrentUser: displayNamecurrentUser);
//    }));
//  }
}


