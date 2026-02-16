import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_ninja/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.red.shade50, Colors.white],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/foodninjared.png',
                          width: 120,
                          height: 120,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                        SizedBox(height: 18),
                        TextFormField(
                          controller: _emcontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: _validateEmail,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _pscontroller,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          value: _rememberMe,
                          title: Text('Remember me'),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool value) {
                            _onChange(value ?? false);
                          },
                        ),
                        SizedBox(height: 8),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          minWidth: double.infinity,
                          height: 48,
                          child: Text('Login'),
                          color: Colors.red.shade700,
                          textColor: Colors.white,
                          elevation: 0,
                          onPressed: _onPress,
                        ),
                        SizedBox(height: 12),
                        InkWell(
                          onTap: _onRegister,
                          child: Text(
                            'Create new account',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: _onForgot,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPress() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _savePref(_rememberMe);
    Toast.show(
      "Login success (demo mode)",
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
  }

  void _onForgot() {
    Toast.show(
      "Please contact admin to reset password",
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  Future<void> _loadPref() async {
    _prefs = await SharedPreferences.getInstance();
    final String email = (_prefs.getString('email')) ?? '';
    final String pass = (_prefs.getString('password')) ?? '';
    final bool remember = (_prefs.getBool('rememberme')) ?? false;
    if (email.isNotEmpty || pass.isNotEmpty) {
      setState(() {
        _emcontroller.text = email;
        _pscontroller.text = pass;
        _rememberMe = remember;
      });
    }
  }

  Future<void> _savePref(bool value) async {
    _prefs = _prefs ?? await SharedPreferences.getInstance();
    if (value) {
      await _prefs.setString('email', _emcontroller.text.trim());
      await _prefs.setString('password', _pscontroller.text);
      await _prefs.setBool('rememberme', true);
      return;
    } else {
      await _prefs.setString('email', '');
      await _prefs.setString('password', '');
      await _prefs.setBool('rememberme', false);
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    return Future.value(false);
  }

  String _validateEmail(String value) {
    final String email = value.trim();
    if (email.isEmpty) {
      return 'Please enter email';
    }
    if (!email.contains('@') || !email.contains('.')) {
      return 'Please enter valid email';
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Minimum 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _emcontroller.dispose();
    _pscontroller.dispose();
    super.dispose();
  }
}
