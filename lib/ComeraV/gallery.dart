import 'dart:io';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:techstagram/ComeraV/camera_screen.dart';
import 'package:techstagram/ComeraV/video_preview.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:techstagram/Signup/components/or_divider.dart';
//import 'package:techstagram/model/user.dart';
//import 'package:techstagram/models/user.dart';
//import 'package:techstagram/resources/auth.dart';
//import 'dart:io';

import 'package:techstagram/resources/uploadimage.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  String currentFilePath;

int indexd;



  @override
  void initState() {



    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: GestureDetector(
        onTap: (){
//          Navigator.pop(
//            context,
//            MaterialPageRoute(
//              builder: (context) => CameraScreen(),
//            ),
//          );
      },
        child: Stack(
          children: [

            FutureBuilder(
              future: _getAllImages(),
              builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
                if (!snapshot.hasData) {
                  if (snapshot.data.isEmpty){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CameraScreen();
                        },
                      ),
                    );
                  }
                  return Container(
                    color: Colors.redAccent,
                  );
                }
                print('${snapshot.data.length} ${snapshot.data}');
                if (snapshot.data.length == 0) {
                  Navigator.pop(context);
                }

                return PageView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    indexd = snapshot.data.length;
                    print(indexd);
                    currentFilePath = snapshot.data[index].path;
                    var extension = path.extension(snapshot.data[index].path);
                    if (extension == '.jpeg') {
                      return Container(
                        height: 300,
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Image.file(
                          File(snapshot.data[index].path),
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (extension == '.jpeg') {
                      return VideoPreview(
                        videoPath: snapshot.data[index].path,
                      );
                    }
                    else{
                      return Text("cmcv",style: TextStyle(
                        color: Colors.white
                      ),);
                    };
                  },
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.only(top: 30.0,left: 6.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Positioned(
                  child: IconButton(icon: Icon(Icons.close,
                  color: Colors.grey.shade200,
                  size: 30.0,), onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {

                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text("Discard post ?"),
                            content: Text("If you go back now, you will lose your post.", style: TextStyle(
                                color: Colors.deepPurple
                            )),
                            actions: <Widget>[
                             Padding(
                               padding: const EdgeInsets.only(right: 120.0),

                                 child: Column(
                                   children: [
                                     FlatButton(
                                       child: Text("Discard",style:
                                       TextStyle(
                                         color: Colors.red,
                                       ),),
                                       onPressed: () {
                                         _deleteFile();
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                             builder: (context) {
                                               return CameraScreen();
                                             },
                                           ),
                                         );
                                       },
                                     ),
                                     FlatButton(
                                       child: Text("Keep",style:
                                       TextStyle(
                                         color: Colors.black,
                                       ),),
                                       onPressed: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                             builder: (context) {
                                               return CameraScreen();
                                             },
                                           ),
                                         );
                                       },
                                     )
                                   ],
                                 ),

                             )
                            ],
                          );
                        });
                  },
                  )
                ),
              ),
            ),

//            Padding(
//              padding: const EdgeInsets.only(top: 30.0,right: 6.0),
//              child: Align(
//                alignment: Alignment.topRight,
//                child: Positioned(
//                  child: IconButton(
//
//                    onPressed: () {
//                      _deleteFile();
//                    },
//
//                    icon: Icon(Icons.delete_outline,
//                      color: Colors.grey.shade200,),
//
//                  ),
//                ),
//              ),
//            ),

            Padding(
              padding: const EdgeInsets.only(right: 30.0,bottom: 3.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Positioned(
                  width: 20.0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child:ButtonTheme(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        width: 230.0,
                        child: FlatButton(
                          color: Colors.transparent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UploadImage(file: File(currentFilePath),)),
                            );
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 3.0,),
                                child: Icon(FontAwesomeIcons.angleDoubleRight,
                                  color: Colors.grey.shade200,),
                              ),
                              Text("Swipe right for saved posts",style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade200,
//                                fontSize: 15.0
                              ),),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Positioned(
                  width: 20.0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child:ButtonTheme(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        width: 85.0,
                        child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UploadImage(file: File(currentFilePath),)),
                            );
                          },
                          child: Row(
                            children: [
                              Text("Post",style: TextStyle(
                                  fontWeight: FontWeight.w400
                              ),),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),

    );
  }

  _shareFile() async {
    var extension = path.extension(currentFilePath);
    await Share.file(
      'image',
      (extension == '.jpeg') ? 'image.jpeg' : '	video.mp4',
      File(currentFilePath).readAsBytesSync(),
      (extension == '.jpeg') ? 'image/jpeg' : '	video/mp4',
    );
  }

  _deleteFile() {
    final dir = Directory(currentFilePath);
    dir.deleteSync(recursive: true);
    print('deleted');
    setState(() {});
  }


//  Future uploadFile() async {
//
//    StorageReference storageReference = FirebaseStorage.instance
//        .ref()
//        .child('posts/${Path.basename(currentFilePath)}}');
//    StorageUploadTask uploadTask = storageReference.putFile(File(currentFilePath));
//    await uploadTask.onComplete;
//    print('File Uploaded');
//    storageReference.getDownloadURL().then((fileURL) {
//      setState(() {
//        currentFilePath = fileURL;
//      });
//    });
//  }

  Future<List<FileSystemEntity>> _getAllImages() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    return _images;
  }
}
