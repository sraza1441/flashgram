import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:techstagram/ui/HomePage.dart';

//import 'package:instagram/main.dart';
//import 'package:instagram/models/appbar.dart';

class FeedsPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<FeedsPage> {
//  static int page = 1;
//  static Post the_post = post1;

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      // user have just tapped on screen (no dragging)
      return;

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

  @override
  Widget build(BuildContext context) {

  return Scaffold(
    body: Container(
      child: Text("Coming Soon..."),
    ),
  );
  }


}

//old code

//import 'package:flutter/material.dart';
//import 'package:techstagram/model/feed.dart';
//import 'package:techstagram/widgets/feed_card1.dart';
//import 'package:techstagram/widgets/feed_card2.dart';

//import 'package:techstagram/widgets/feed_card3.dart';
//
//class FeedsPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//
//    final pageTitle = Padding(
//      padding: EdgeInsets.only(top: 1.0, bottom: 30.0),
//      child: Text(
//        "Feed",
//        style: TextStyle(
//          fontWeight: FontWeight.bold,
//          color: Colors.black,
//          fontSize: 40.0,
//        ),
//      ),
//    );
//
//    return Scaffold(
//      body: SingleChildScrollView(
//        child: Container(
//          color: Colors.grey.withOpacity(0.1),
//          padding: EdgeInsets.only(top: 40.0),
//          width: MediaQuery.of(context).size.width,
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 30.0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    pageTitle,
//                    FeedCard1(feed: feeds[0]),
//                    SizedBox(
//                      height: 10.0,
//                    ),
//                    FeedCard2(
//                      feed: feeds[1],
//                    ),
//                    SizedBox(
//                      height: 10.0,
//                    ),
//                    FeedCard3(
//                      feed: feeds[2],
//                    ),
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
