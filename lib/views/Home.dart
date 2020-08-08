import 'package:blogapp/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_blog.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  CrudMethods crudMethods = new CrudMethods();

  QuerySnapshot blogSnapshot;



  Widget BlogList(){
    return blogSnapshot !=null ? Column(
        children: <Widget>[
           ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: blogSnapshot.documents.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context,index){
                return  BlogTile(
                  authorName: blogSnapshot.documents[index].data['authorName'],
                  title: blogSnapshot.documents[index].data['title'],
                  imageUrl: blogSnapshot.documents[index].data['imageUrl'],
                  description: blogSnapshot.documents[index].data['description'],
                );
              })
        ],
      ):Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    crudMethods.getData().then((result){
      blogSnapshot = result;});
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
      ),

      body: BlogList(),
      floatingActionButton: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30),
              child: FloatingActionButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CreateBlog(),
                  ));
                },
                child: Icon(Icons.add_a_photo),
              ),
            )
          ],
        ),
      ),
    );
  }
}

  class BlogTile extends StatelessWidget {
  String authorName,description ,title, imageUrl;


  BlogTile({@required this.description,@required this.title,@required this.imageUrl,@required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      height: 180,
      child: Stack(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(06),
              child: Image.network(imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
          ),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.black54.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title,style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                SizedBox(height: 20,),
                Text(authorName,style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                SizedBox(height: 20,),
                Text(description,style: TextStyle(fontSize: 8, fontWeight: FontWeight.w300),),
              ],
            ),
          )
        ],
      ),
    );
  }
}


