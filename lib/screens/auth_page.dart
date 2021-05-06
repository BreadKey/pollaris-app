import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pollaris_app/blocs/auth_bloc.dart';
import 'package:pollaris_app/models/user.dart';
import 'package:pollaris_app/screens/colors.dart';
import 'package:pollaris_app/screens/home_page.dart';
import 'package:pollaris_app/screens/strings.dart';
import 'package:provider/provider.dart';

enum _Mode { signIn, signUp }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late AuthBloc authBloc;

  bool onAuthorize = true;
  User? user;

  bool obscureText = true;

  late TextEditingController idController;
  late TextEditingController nicknameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool onSign = false;

  final formKey = GlobalKey<FormState>();

  late FocusNode nicknameNode;
  late FocusNode passwordNode;
  late FocusNode confirmPasswordNode;

  _Mode mode = _Mode.signIn;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc();

    authBloc.authorize().then((user) {
      this.user = user;

      if (user == null) {
        setState(() {
          onAuthorize = false;
        });
      } else {
        onSignInSucceed(user);
      }
    });

    idController = TextEditingController();
    nicknameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    nicknameNode = FocusNode();
    passwordNode = FocusNode();
    confirmPasswordNode = FocusNode();
  }

  @override
  void dispose() {
    idController.dispose();
    nicknameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nicknameNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ultraViolet,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Pollaris",
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Colors.white),
              ),
              onAuthorize
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.618,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Card(
                            elevation: 2,
                            child: Form(
                                key: formKey,
                                child: AutofillGroup(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildId(context),
                                      buildNickname(context),
                                      buildPassword(context),
                                      buildConfirmPassword(context)
                                    ],
                                  ),
                                ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _Mode.values
                              .map((mode) => buildSignButton(context, mode))
                              .toList()
                                ..insert(
                                    1,
                                    const VerticalDivider(
                                      color: Colors.transparent,
                                    )),
                        )
                      ])),
            ],
          ),
        )),
      );

  Widget buildId(BuildContext context) => TextFormField(
        autofocus: true,
        decoration: InputDecoration(labelText: Strings.of(context).id),
        autofillHints: [AutofillHints.username],
        controller: idController,
        validator: (value) {
          if (value?.isNotEmpty != true) {
            return Strings.of(context).enterId;
          }
        },
        onEditingComplete: () {
          final nextNode = mode == _Mode.signIn ? passwordNode : nicknameNode;
          nextNode.requestFocus();
        },
      );

  Widget buildNickname(BuildContext context) => mode == _Mode.signUp
      ? TextFormField(
          focusNode: nicknameNode,
          decoration: InputDecoration(labelText: Strings.of(context).nickname),
          controller: nicknameController,
          validator: (value) {
            if (mode == _Mode.signUp) {
              if (value?.isNotEmpty != true) {
                return Strings.of(context).enterNickname;
              }
            }
          },
          onEditingComplete: () {
            passwordNode.requestFocus();
          },
        )
      : const SizedBox.shrink();

  Widget buildPassword(BuildContext context) => TextFormField(
        focusNode: passwordNode,
        decoration: InputDecoration(
            labelText: Strings.of(context).password,
            suffixIcon: buildToggleObsecureButton(context)),
        obscureText: obscureText,
        autofillHints: [AutofillHints.password],
        controller: passwordController,
        validator: (value) {
          if (value?.isNotEmpty != true) {
            return Strings.of(context).enterPasword;
          }
        },
        onEditingComplete: onSign
            ? null
            : mode == _Mode.signIn
                ? sign
                : confirmPasswordNode.requestFocus,
      );

  Widget buildConfirmPassword(BuildContext context) => mode == _Mode.signUp
      ? TextFormField(
          focusNode: confirmPasswordNode,
          decoration: InputDecoration(
              labelText: Strings.of(context).confirmPassword,
              suffixIcon: buildToggleObsecureButton(context)),
          obscureText: obscureText,
          controller: confirmPasswordController,
          validator: (value) {
            if (mode == _Mode.signUp) {
              if (passwordController.text != value) {
                return Strings.of(context).notMatchPassword;
              }
            }
          },
        )
      : const SizedBox.shrink();

  Widget buildToggleObsecureButton(BuildContext context) => IconButton(
      icon: Icon(obscureText
          ? Icons.visibility_rounded
          : Icons.visibility_off_rounded),
      onPressed: () {
        setState(() {
          obscureText = !obscureText;
        });
      });

  Future sign() async {
    if (!formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      onSign = true;
    });

    switch (mode) {
      case _Mode.signIn:
        await signIn();
        break;
      case _Mode.signUp:
        await signUp();
        break;
    }

    setState(() {
      onSign = false;
    });
  }

  Widget buildSignButton(BuildContext context, _Mode mode) => Expanded(
      child: ElevatedButton(
          onPressed: onSign
              ? null
              : () {
                  if (this.mode != mode) {
                    setState(() {
                      this.mode = mode;
                    });
                  } else {
                    sign();
                  }
                },
          child: Text(mode == _Mode.signIn
              ? Strings.of(context).signIn
              : Strings.of(context).signUp)));

  Future signIn() async {
    final succeed =
        await authBloc.signIn(idController.text, passwordController.text);

    if (succeed) {
      final user = await authBloc.authorize();
      onSignInSucceed(user!);
    } else {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("아이디나 패스워드가 일치하지 않습니다!")));
    }
  }

  Future signUp() async {
    final error = await authBloc.signUp(
        idController.text, nicknameController.text, passwordController.text);

    if (error == null) {
      await signIn();
    }
  }

  void onSignInSucceed(User user) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Provider.value(
              value: user,
              child: HomePage(),
            )));
  }
}
