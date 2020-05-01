import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'StudentDetail.dart';
import 'MyClipper.dart';

class StudentApp extends StatefulWidget {
  @override
  _StudentAppState createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  final String url = 'http://tomaszgadek.com/api/students/';
  List data;
  List filtrData;
  FocusNode focusNode = FocusNode();
  var _controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async{
    var response = await http.get(
        Uri.encodeFull(url),
        headers: {"Accept": "application/json"}
        );

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      data = convertDataToJson;
      filtrData = data;
    });

    return "Success";

  }

  Future<void> refresh() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      getJsonData();
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    child: Center(
                      child: Text(
                        "TiJO App",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: "Poppins",
                          color: Colors.white
                        ),
                      ),
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF3383CD),
                          Color(0xFF11249F)
                        ]
                      )
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:15),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search
                          ),
                          hintText: "Search",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: (){
                              _controller.clear();
                              setState(() {
                                filtrData = data;
                                FocusScope.of(context).unfocus();
                              });
                            },
                          ),
                        ),
                        onChanged: (string) {
                          setState(() {
                            filtrData = data.where((element) => element['index'].contains(string)).toList();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: filtrData == null ? 0: filtrData.length,
                            itemBuilder: (BuildContext context, int index){
                              return Card(
                                child: ExpansionTile(
                                  title: Text(
                                    filtrData[index]['index'],
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Mark: "+filtrData[index]['mark'].toString(),
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Group: "+filtrData[index]['group'],
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Lecture Points: "+filtrData[index]['lecturePoints'].toString(),
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Homework Points: "+filtrData[index]['homeworkPoints'].toString(),
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Presence counter: "+filtrData[index]['presenceCounter'].toString(),
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Absence counter: "+filtrData[index]['absenceCounter'].toString(),
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "All points: "+filtrData[index]['allPoints'].toString(),
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) => StudentAppDetails(index:filtrData[index]['index'],group:filtrData[index]['group'])
                                            )
                                          );
                                      },
                                      child: Text(
                                        "More info",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins"
                                        ),
                                      ),
                                      color: Color(0xFF11249F),
                                    )
                                  ],
                                ),
                              );
                            }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}