import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:future_sale/screens/catalogue/catalogue.dart';
import 'package:future_sale/screens/sign_in/sign_in_confirm.dart';
import 'package:future_sale/widgets/screen_container.dart';
import 'package:future_sale/widgets/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInLogin extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SignInLogin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _phoneController = TextEditingController();
  String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ScreenContainer(
        child: ContentLayout(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Logo(),
                      _buildForm(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text('OR'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      _buildSocialButtons(),
                    ],
                  ),
                ),
              ),
              Copyright(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter Mobile Phone',
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _handleMobilePhoneSignIn(),
        ),
        SizedBox(
          height: 8,
        ),
        OutlineButton(
          onPressed: _handleMobilePhoneSignIn,
          child: Text('Sign In'),
        ),
        FlatButton(
          onPressed: _handleMobilePhoneSignIn,
          child: Text('Register'),
        )
      ],
    );
  }

  Widget _buildSocialButtons() {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlatButton(
          color: Colors.deepOrangeAccent,
          onPressed: _handleGoogleSignIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MaterialCommunityIcons.google,
                color: Colors.white,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Sign In',
                style: theme.accentTextTheme.button,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 8,
        ),
        FlatButton(
          color: Colors.blueAccent,
          onPressed: _handleFacebookSignIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MaterialCommunityIcons.facebook,
                color: Colors.white,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Sign In',
                style: theme.accentTextTheme.button,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMobilePhoneSignIn() async {
    FocusScope.of(context).requestFocus(FocusNode());

    final firebaseAuth = FirebaseAuth.instance;

    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (phoneAuthCredential) async {
          try {
            await firebaseAuth.signInWithCredential(phoneAuthCredential);

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => CatalogueList(),
            ));
          } on Exception catch (e) {
            print(e);
          }
        },
        verificationFailed: (error) {
          if (error.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (verificationId, forceResendingToken) async {
          Navigator.of(context).push(MaterialPageRoute<bool>(
            builder: (_) => SignInConfirm(
              verificationId: verificationId,
              forceResendingToken: forceResendingToken,
            ),
          ));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Wrong user or password, please check and try again.';
        });
      }
    }
  }

  void _handleGoogleSignIn() async {
    try {
      await GoogleSignIn().disconnect();
    } on Exception catch (e) {}

    try {
      // Trigger the authentication flow

      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      if (await FirebaseAuth.instance.signInWithCredential(credential) != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CatalogueList(),
        ));
      }
    } on Exception catch (e) {}
  }

  void _handleFacebookSignIn() async {
    // // Trigger the sign-in flow
    // final result = await FacebookAuth.instance.login();
    //
    // // Create a credential from the access token
    // final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.token);
    //
    // // Once signed in, return the UserCredential
    // if (await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential) != null) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (_) => CatalogueList(),
    //   ));
    // }

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Facebook login requires a project in FB.'),
    ));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
