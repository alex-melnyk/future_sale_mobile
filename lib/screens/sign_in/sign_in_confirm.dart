import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_sale/screens/screens.dart';
import 'package:future_sale/widgets/content_layout.dart';
import 'package:future_sale/widgets/screen_container.dart';
import 'package:future_sale/widgets/widgets.dart';

class SignInConfirm extends StatefulWidget {
  const SignInConfirm({
    Key key,
    this.verificationId,
    this.forceResendingToken,
  }) : super(key: key);

  final String verificationId;
  final int forceResendingToken;

  @override
  _SignInConfirmState createState() => _SignInConfirmState();
}

class _SignInConfirmState extends State<SignInConfirm> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                children: [Logo(), _buildForm()],
              ),
            ),
          ),
          Copyright(),
        ],
      ))),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _codeController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter Verification Code',
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _handleCodeSend(),
        ),
        SizedBox(
          height: 8,
        ),
        OutlineButton(
          onPressed: _handleCodeSend,
          child: Text('Send Verification Code'),
        ),
      ],
    );
  }

  void _handleCodeSend() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _codeController.text,
    );

    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

    Navigator.of(context)
      ..popUntil((route) => route.isFirst)
      ..pushReplacement(MaterialPageRoute(
        builder: (_) => Home(),
      ));
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
