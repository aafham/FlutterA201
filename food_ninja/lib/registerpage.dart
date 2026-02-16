import 'package:flutter/material.dart';
import 'package:food_ninja/loginpage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  final TextEditingController _phcontroller = TextEditingController();

  bool _passwordVisible = false;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.red.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.0),
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
                    children: <Widget>[
                      Image.asset(
                        'assets/images/foodninjared.png',
                        width: 110,
                        height: 110,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      SizedBox(height: 18),
                      TextFormField(
                        controller: _namecontroller,
                        keyboardType: TextInputType.name,
                        decoration: _inputDecoration('Name', Icons.person),
                        validator: _validateName,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _emcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Email', Icons.email),
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _phcontroller,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration('Mobile', Icons.phone),
                        validator: _validatePhone,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _pscontroller,
                        decoration:
                            _inputDecoration('Password', Icons.lock).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
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
                        child: Text('Register'),
                        color: Colors.red.shade700,
                        textColor: Colors.white,
                        elevation: 0,
                        onPressed: _onRegister,
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: _onLogin,
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }

  void _onRegister() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final String name = _namecontroller.text.trim();
    final String email = _emcontroller.text.trim();
    final String password = _pscontroller.text;
    final String phone = _phcontroller.text.trim();

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration...");
    await pr.show();

    try {
      final res = await http.post(
        "https://slumberjer.com/foodninjav2/php/register_user.php",
        body: {
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
        },
      );
      final String body = res.body.toLowerCase();
      if (body.contains("success") || body.contains("succes")) {
        Toast.show(
          "Registration success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        if (_rememberMe) {
          await _savePref();
        }
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          );
        }
      } else {
        Toast.show(
          "Registration failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    } catch (err) {
      Toast.show(
        "Network error. Please try again.",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    } finally {
      await pr.hide();
    }
  }

  void _onLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  Future<void> _savePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String email = _emcontroller.text.trim();
    final String password = _pscontroller.text;

    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('rememberme', true);
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  String _validateName(String value) {
    final String name = value.trim();
    if (name.isEmpty) {
      return 'Please enter name';
    }
    if (name.length < 3) {
      return 'Name is too short';
    }
    return null;
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

  String _validatePhone(String value) {
    final String phone = value.trim();
    if (phone.isEmpty) {
      return 'Please enter mobile number';
    }
    if (phone.length < 9) {
      return 'Please enter valid mobile number';
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
    _namecontroller.dispose();
    _emcontroller.dispose();
    _pscontroller.dispose();
    _phcontroller.dispose();
    super.dispose();
  }
}
