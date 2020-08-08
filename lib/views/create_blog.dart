import 'package:blogapp/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

   String authorName, title, desc;
   bool isLoading = false;
   CrudMethods crudMethods = new CrudMethods();

   File _image;
   final picker = ImagePicker();
   Future getImage() async {
     final pickedFile = await picker.getImage(source: ImageSource.gallery);
     if(pickedFile!=null){
       final cropped = await ImageCropper.cropImage(
         sourcePath: pickedFile.path,
         aspectRatio: CropAspectRatio(
           ratioX: 1,
           ratioY: 1,
         ),
         compressQuality: 100,
         maxWidth: 300,
         maxHeight: 180,
         compressFormat: ImageCompressFormat.jpg,
       );
       this.setState(() {
         _image = File(cropped.path);
       });
     }
   }

   uploadBlog() async
   {
     if(_image != null){
       setState(() {
         isLoading = true;
       });

       /// uploading image to firebase storage
     StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImages").child("${randomAlphaNumeric(9)}.jpg");
     final StorageUploadTask task = firebaseStorageRef.put(_image);

     var Download = await (await task.onComplete).ref.getDownloadURL();

     print("This is URL $Download ");

     Map<String, String> blogMap = {
       "imageUrl" : Download,
       "authorName" : authorName,
       "title" : title,
       "description" : desc,
     };

     crudMethods.addData(blogMap).then((result){
       Navigator.pop(context);
     });

     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Flutter",style: TextStyle(
              fontSize: 22,
            ),),

            Text("Blog",style: TextStyle(
              fontSize: 22,
              color: Colors.lightBlue,
            ),)
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
               uploadBlog();
            },
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child:Icon(Icons.file_upload)
            ),
          ),
        ],
      ),
      body: isLoading ? Container(
        child: CircularProgressIndicator(),
        alignment: Alignment.center,
      ) : Container(
        child: Column(
          children: <Widget>[

            GestureDetector(
              onTap: (){getImage();},
              child: _image!=null ? Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(_image, fit: BoxFit.cover,)),
      ): Container(
                height: 180,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.blueAccent,
                  ),

                  child: Icon(Icons.add_circle, size: 80,),
                ),
            ),


            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: TextField(
                decoration: InputDecoration(hintText: "Author Name"),
                onChanged: (val){
                  title = val;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: TextField(
                decoration: InputDecoration(hintText: "Title"),
                onChanged: (val){
                  authorName = val;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: TextField(
                decoration: InputDecoration(hintText: "description"),
                onChanged: (val){
                  desc = val;
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
