import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:private_call/components/fingreauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'security_screen.dart';
import 'package:private_call/screens/contact_screen.dart';
import 'package:private_call/database/TaskModel.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final TodoHelper _todoHelper = TodoHelper();
  List<TaskModel> tasks = [];
  //Fingure Print Constants
  final LocalAuthentication auth = LocalAuthentication();

  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  permissionMethod() async {
    if (await Permission.contacts.request().isGranted) {
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('fig', false);
      return prefs.commit();
    }
    Map<Permission, PermissionStatus> statuses =
        await [Permission.contacts].request();
  }

  Future<bool> getBoolPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool op = prefs.getBool('fig');

    checkFigOnStart(op);
  }

  checkFigOnStart(bool op) {
    if (op == true) {
      print('Hello fuckjer');
      _authenticate();
    }
  }

  @override
  void initState() {
    permissionMethod();
    getBoolPreference();
    super.initState();
  }

  getFavContacts() async {
    List<TaskModel> list = await _todoHelper.getAllTask();
    setState(() {
      tasks = list;
    });
  }

  //For biometic (Fingre print)
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Unlock App with Your Fingerprint',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
      if (_authorized == 'Not Authorized') {
        _cancelAuthentication();
        exit(0);
      }
    });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          Container(
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFA236FE),
                  blurRadius: 30.0,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFA236FE),
                  // Color(0xFF201F32),
                  Color(0xFF6B00FE),
                  Color(0xFFDD00FD)
                ],
              ),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 25.0),
            child: Text(
              'Favorite',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              // padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                    child: Text('Click Here To See Contacts'),
                    onPressed: () {
                      getFavContacts();
                    },
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              _todoHelper.deleteTask(tasks[index].id);
                            });
                          },
                          // leading: Text("${tasks[index].id}"),
                          title: Text("${tasks[index].name}"),
                          subtitle: Text("${tasks[index].phoneno}"),
                          trailing: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: tasks.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
