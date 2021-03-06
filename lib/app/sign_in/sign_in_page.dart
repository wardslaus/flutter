import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:wardslaus/app/sign_in/developer_menu.dart';
import 'package:wardslaus/app/sign_in/email_password/email_password_sign_in_page.dart';
import 'package:wardslaus/app/sign_in/email_link/email_link_sign_in_page.dart';
import 'package:wardslaus/app/sign_in/sign_in_manager.dart';
import 'package:wardslaus/app/sign_in/social_sign_in_button.dart';
import 'package:wardslaus/common_widgets/platform_exception_alert_dialog.dart';
import 'package:wardslaus/constants/keys.dart';
import 'package:wardslaus/constants/strings.dart';
import 'package:wardslaus/services/apple_sign_in_available.dart';
import 'package:wardslaus/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPageBuilder extends StatelessWidget {
  // P<ValueNotifier>
  //   P<SignInManager>(valueNotifier)
  //     SignInPage(value)
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) =>
            Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, SignInManager manager, __) => SignInPage._(
              isLoading: isLoading.value,
              manager: manager,
              title: 'Firebase Auth Demo',
            ),
          ),
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage._({Key key, this.isLoading, this.manager, this.title})
      : super(key: key);
  final SignInManager manager;
  final String title;
  final bool isLoading;

  static const Key googleButtonKey = Key('google');
  static const Key facebookButtonKey = Key('facebook');
  static const Key emailPasswordButtonKey = Key('email-password');
  static const Key emailLinkButtonKey = Key('email-link');
  static const Key anonymousButtonKey = Key(Keys.anonymous);

  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      await manager.signInWithApple();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final navigator = Navigator.of(context);
    await EmailPasswordSignInPage.show(
      context,
      onSignedIn: navigator.pop,
    );
  }

  Future<void> _signInWithEmailLink(BuildContext context) async {
    final navigator = Navigator.of(context);
    await EmailLinkSignInPage.show(
      context,
      onSignedIn: navigator.pop,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _buildSignIn(context)




    );
  }
/*  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[200],
      body: _buildSignIn(context),
    );
  }*/



  Widget _buildSignIn(BuildContext context) {
    final appleSignInAvailable = Provider.of<AppleSignInAvailable>(context);
    // Make content scrollable so that it fits on small screens
    return SingleChildScrollView(

      child: Container(

        child: Column(

          children: <Widget>[


            new Card(
              color: Colors.grey[100],
              margin: new EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 150.0, bottom: 80.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 8.0,
              child: new Padding(
              padding: new EdgeInsets.all(25.0),
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,

                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: new BorderRadius.circular(48.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/logo.png'),
                        width: 200.0,

                      ),
                    ),
                    SizedBox(height: 32.0),
                    if (appleSignInAvailable.isAvailable) ...[
                      AppleSignInButton(
                        // TODO: add key when supported
                        style: ButtonStyle.black,
                        type: ButtonType.signIn,
                        onPressed: isLoading ? null : () => _signInWithApple(context),
                      ),
                      SizedBox(height: 8),
                    ],
                    SocialSignInButton(
                      key: googleButtonKey,
                      assetName: 'assets/go-logo.png',
                      text: Strings.signInWithGoogle,
                      onPressed: isLoading ? null : () => _signInWithGoogle(context),
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    SocialSignInButton(
                      key: facebookButtonKey,
                      assetName: 'assets/fb-logo.png',
                      text: Strings.signInWithFacebook,
                      textColor: Colors.white,
                      onPressed: isLoading ? null : () => _signInWithFacebook(context),
                      color: Color(0xFF334D92),
                    ),
                    SizedBox(height: 8),
                    SignInButton(
                      key: emailPasswordButtonKey,
                      text: Strings.signInWithEmailPassword,
                      onPressed:
                          isLoading ? null : () => _signInWithEmailAndPassword(context),
                      textColor: Colors.white,
                      color: Colors.teal[700],
                    ),



                  ],
                ),
              ),
        ),
        ],
        ),
      ),
    );
  }
}
