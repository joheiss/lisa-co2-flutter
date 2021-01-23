import 'package:flutter/material.dart';
import 'package:try_grid/app/blocs/bloc.dart';

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {

  String message = '';
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 100.0),
            _buildEmailInputField(context, _emailController),
            _buildPasswordInputField(context, _passwordController),
            SizedBox(height: 25.0),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInputField(BuildContext context, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Emailadresse',
        hintText: 'Bitte geben Sie ihre Emailadresse ein.',
        errorText: message,
        errorStyle: TextStyle(fontSize: 12.0),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: controller,
    );
  }

  Widget _buildPasswordInputField(BuildContext context, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Passwort',
        hintText: 'Bitte geben Sie ihr Passwort ein.',
        errorText: message,
        errorStyle: TextStyle(fontSize: 12.0),
      ),
      obscureText: true,
      controller: controller,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        print('(TRACE) email: ${_emailController.text}, password: ${_passwordController.text}');
        final user = await bloc.signIn(_emailController.text, _passwordController.text);
        if (user == null) {
          print('(TRACE) Sign in FAILED');
          setState(() {
            message = 'Anmeldung ist fehlgeschlagen! Bitte versuche Sie es erneut';
          });
        } else {
          print('(TRACE) Sign in OK, go to home');
          // FocusScope.of(context).requestFocus(new FocusNode());
          await Navigator.of(context).popAndPushNamed('/home');
          // Navigator.pop(context);
        }
      },
      child: Text('Anmelden'),
      color: Theme.of(context).accentColor,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
