import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool figa = false;
  //Fingure Print Constants
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  //Shared Preferances for to store bool for switch
  Future<bool> saveBoolPreference(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('fig', val);
    return prefs.commit();
  }

  getBoolPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool op = prefs.getBool('fig');
    updatedValue(op);
  }

  void updatedValue(bool op) {
    setState(() {
      figa = op;
      print(figa);
    });
  }

  @override
  void initState() {
    bool figa = false;
    getBoolPreference();
    super.initState();
  }

  //Switch
  onSwitchValueChanged(bool newVal) {
    setState(() {
      saveBoolPreference(newVal);
      getBoolPreference();
      if (newVal == true) {
        _checkBiometrics();
        _getAvailableBiometrics();
        _authenticate();
      }
    });
  }

  //For biometic (Fingre print)
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Confirm fingerprint',
          useErrorDialogs: true,
          stickyAuth: true);
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
      print('Check bio: $_authorized');
      if (_authorized == 'Not Authorized') {
        bool newVal = false;
        saveBoolPreference(newVal);
        getBoolPreference();
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
            // color: Theme.of(context).primaryColor,
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
              'Security Settings',
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
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        title: Text('Unlock with fingerprint'),
                        subtitle: Text(
                            "When enabled,you'll need to use figerprint to open this app.You can still answer calls if app is locked"),
                        trailing: Switch(
                            value: figa,
                            onChanged: (newVal) {
                              onSwitchValueChanged(newVal);
                            }),
                      ),
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
