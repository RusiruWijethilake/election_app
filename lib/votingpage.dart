import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  State<VotingPage> createState() => _MyVotingPage();
}

class _MyVotingPage extends State<VotingPage> {

  final String backendUrl = "http://192.168.8.160:8002";

  Future<Map<dynamic, dynamic>> _makeGetRequest(BuildContext context, String userid) async {
    var url = Uri.parse("$backendUrl/verifyVoter?id=$userid&source=1");
    http.Response response = await http.get(url);

    int statusCode = response.statusCode;
    Map<dynamic, dynamic> data = jsonDecode(response.body);

    return data;
  }

  Future _submitVote(BuildContext _rootContext, String userId, String candidateId) async {
    var url = Uri.parse("$backendUrl/enrollVote?user_id=$userId&candidate_id=$candidateId");
    http.Response response = await http.post(url);
    int statusCode = response.statusCode;

    print(statusCode);
    print(response.body);

    showDialog(context: context, builder: (context) {
      return SimpleDialog(
        title: Text("Successful!!!"),
        children: [
          Text("Your vote has been successfully submitted."),
          ElevatedButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Got it")),
        ],
      );
    },);
    Navigator.popAndPushNamed(_rootContext, '/landing');
  }

  int? _value = -1;

  void _handleRadioValueChanged(int value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    BuildContext _rootContext = context;

    final args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Vote Now!"),
      ),
      body: Center(
        child: StreamBuilder(
          stream: _makeGetRequest(context, args.toString()).asStream(),
          builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
            if(snapshot.hasData){
              if(snapshot.data!["data"] == "User already voted"){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("User already voted!"),
                    ElevatedButton(onPressed: () {
                      Navigator.popAndPushNamed(context, '/landing');
                    }, child: Text("Start Over!!!")),
                  ],
                );
              }else{
                List listData = snapshot.data!["data"] as List;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Select 1 candidate from the list"),
                    Text(listData.toString()),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                      child: SizedBox(
                        height: 400,
                        width: double.maxFinite,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var value in listData)
                                ListTile(
                                  title: Text(value["candidate_name"]),
                                  leading: Text(value["candidate_no"]),
                                  subtitle: Text(value["candidate_party"]),
                                  trailing: Radio(
                                    value: int.parse(value["id"].toString()),
                                    groupValue: _value,
                                    onChanged: (value) {
                                      _handleRadioValueChanged(value!);
                                    },
                                  ),
                                  tileColor: Colors.white70,
                                )
                            ],
                          )
                        ),
                      ),
                    ),
                    ElevatedButton(onPressed: () {
                      if(_value != -1){
                        _submitVote(_rootContext, args.toString(), _value!.toString());
                      }else{
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("You have to select one candidate!"),
                            actions: [
                              ElevatedButton(onPressed: () {
                                Navigator.pop(context);
                              }, child: Text("Ok"))
                            ],
                          );
                        },);
                      }
                    }, child: Text("Submit Your Vote"))
                  ],
                );
              }
            }

            return Text("Something went wrong");
          }
        )
      ),
    );
  }
}
