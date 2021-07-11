import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title:Text("Attractions")
      ),
      body: AttractionList(),
    );
  }

}

class AttractionList extends StatefulWidget {
  const AttractionList({Key? key}) : super(key: key);

  @override
  _AttractionListState createState() => _AttractionListState();
}

class _AttractionListState extends State<AttractionList> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Attractions').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          padding: EdgeInsets.only(top: 30),
          children: snapshot.data!.docs.map((document) {
            return GestureDetector(
              onTap: () => {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OneAttactions(document.get("Title"),document.get("Image"),document.get("Description"))),
              ),
              },
              child: Container(
                margin: EdgeInsets.only(left: 12,right: 12, bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8, right: 8,bottom: 10,top: 10),
                      child: Image.network(document.get("Image")),
                    ),
                    Align(alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,bottom: 20),
                      child: Text(document.get("Title"),style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ))
                    )
                    ),
                    Align(alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 20),
                          child: Text(document.get("Short Detail"),style: TextStyle(
                              fontSize: 16
                          )),
                        )
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class OneAttactions extends StatelessWidget{
  final String title,image,description;

  OneAttactions(this.title, this.image, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: true,
        title: Text(title),
      ),
      body: Column(
        children: [
          Container(margin: EdgeInsets.only(left: 12,right: 12, bottom: 30,top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Image.network(image)
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12,right: 12,bottom: 10,top: 10),
            child: Align(
            alignment: Alignment.topLeft,
            child: Text(title, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12,right: 12,bottom: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(description,style: TextStyle(
                  fontSize: 16)
            )),
          )
        ]
      )
    );
  }
}



