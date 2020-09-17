import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:launch_review/launch_review.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        body: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color(0x40aaffc3),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Information Page',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          '\nThank you for downloading this clock app. '
                          '\n\nThis was originally designed using Flutter as part of the Flutter Clock Challenge\n',
                          style: TextStyle(fontSize: 16)),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'If you have any comments, queries or suggestions please get in touch via email here.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Center(
                            child: IconButton(
                              icon: Icon(Icons.email),
                              onPressed: () {
                                _launchEmail();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'If you have enjoyed this app pleae give it a positive review. Click here. ',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Center(
                            child: IconButton(
                              icon: Icon(Icons.star),
                              onPressed: () {
                                LaunchReview.launch(
                                  androidAppId: "uk.co.bristolflutterdeveloper.mesmerising_clock",
                                  iOSAppId: "1532195544",
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      usefulLinks(
                          'Flutter Developer',
                          'https://bristolflutterdeveloper.wordpress.com',
                          'If you are interested in producing a similar app at a very reasonable price or to learn about our other apps please see this website for more information.',
                          context),
                    ],
                  ),
                ))));
  }

  void _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'emily_foulkes@hotmail.com',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Widget usefulLinks(
      String title, String url, String description, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 170,
        child: GestureDetector(
          onTap: () {
            if (Platform.isIOS) {
              _launchInBrowser(url);
            } else {
              _launchURL(url, context);
            }
          },
          child: Card(
            color: Color.fromARGB(250, 0, 155, 205),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.launch, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(description,
                      style: TextStyle(color: Colors.white, fontSize: 16))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _launchURL(String url, BuildContext context) async {
  final myController = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Did you mean to leave the app?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(width: 200, child: Text('What is 12 + 17?.')),
              TextField(
                controller: myController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'answer'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Approve'),
            onPressed: () async {
              if (myController.text == '29') {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              }

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}
