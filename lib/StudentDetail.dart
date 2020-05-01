import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class StudentAppDetails extends StatefulWidget {
  StudentAppDetails({Key key, this.index,this.group}) : super(key: key);
  final String index;
  final String group;
  @override
  _StudentAppDetailsState createState() => _StudentAppDetailsState(index,group);
}

class _StudentAppDetailsState extends State<StudentAppDetails> {
  String url = 'http://tomaszgadek.com/api/students/';
  String index;
  String group;
  _StudentAppDetailsState(String index,String group){
    this.url += index;
    this.index = index;
    this.group = group;
  }


  Future<StudentDetail> studentDetail;

  @override
  void initState(){
    super.initState();
    studentDetail = getJsonData();
  }

  isPresence(bool a){
    if(a==true){
      return "Present";
    }else{
      return "Absent";
    }
  }


  Future<StudentDetail> getJsonData() async{
    var response;
    try{
      response = await http.get(
          Uri.encodeFull(url), headers: {"Accept": "application/json"}
      );
    }catch(e){
      return StudentDetail();
    }

    return StudentDetail.fromJson(json.decode(response.body));

  }
  Future<Null> refreshList() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      getJsonData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TiJO App',
          style: TextStyle(
            fontFamily: "Poppins",
          ),),
        centerTitle: true,
        backgroundColor: Color(0xFF11249F),
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        child: Center(
                          child: Text(
                            "Index "+index,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Poppins"
                            ),
                          ),
                        )
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Center(
                          child: Text(
                            "Grupa "+group,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Poppins"
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 20,
                child: FutureBuilder<StudentDetail>(
                  future: studentDetail,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemCount: snapshot.data.labs == null ? 0: snapshot.data.labs.length,
                          itemBuilder: (BuildContext context, int index){
                            return Card(
                              child: ExpansionTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Lab "+(snapshot.data.labs.length-index).toString(),
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Date of lab: "+snapshot.data.labs[index]['dateOfLab'],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      isPresence(snapshot.data.labs[index]['presence']),
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Points: "+snapshot.data.labs[index]['points'].toString(),
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );}
                      );
                    }else if(snapshot.hasError){
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentDetail{
  final String index;
  final String group;
  final List labs;

  StudentDetail({this.index,this.group,this.labs});

  factory StudentDetail.fromJson(Map<String, dynamic> json){
    return StudentDetail(
        index: json['index'],
        group: json['group'],
        labs: json['labs']
    );
  }
}