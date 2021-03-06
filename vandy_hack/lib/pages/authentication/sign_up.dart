import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vandyhack/pages/authentication/SharingPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email, _password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign up'),
          backgroundColor: Colors.teal[200],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.teal[800],
            Colors.teal[600],
            Colors.teal[200]
          ])),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  // ignore: missing_return
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please enter an Email';
                    }
                  },
                  onChanged: (input) => _email = input,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  // ignore: missing_return
                  validator: (input) {
                    if (input.length < 6) {
                      return 'Your password is too weak';
                    }
                  },
                  onChanged: (input) => _password = input,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed: SignUp,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> SignUp() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SharingPage(User: user)));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e.message);
      }
    }
  }
}
