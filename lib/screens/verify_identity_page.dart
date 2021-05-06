import 'package:flutter/material.dart';
import 'package:pollaris_app/blocs/auth_bloc.dart';
import 'package:pollaris_app/models/user.dart';
import 'package:pollaris_app/screens/strings.dart';
import 'package:provider/provider.dart';

class VerifyIdentityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VerifyIdentityPageState();
}

class _VerifyIdentityPageState extends State<VerifyIdentityPage> {
  final phoneNumberFormKey = GlobalKey<FormState>();

  late AuthBloc authBloc;
  late User user;

  late TextEditingController leading;
  late TextEditingController middle;
  late TextEditingController trailing;

  late FocusNode middleNode;
  late FocusNode trailingNode;

  late TextEditingController code;

  bool onRequest = false;
  bool canEnterCode = false;

  bool? isVerified;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc();
    user = context.read();

    leading = TextEditingController()..text = "010";
    middle = TextEditingController();
    trailing = TextEditingController();

    middleNode = FocusNode();
    trailingNode = FocusNode();

    code = TextEditingController();
  }

  @override
  void dispose() {
    leading.dispose();
    middle.dispose();
    trailing.dispose();

    middleNode.dispose();
    trailingNode.dispose();

    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Card(
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: phoneNumberFormKey,
                    child: Row(children: [
                      buildPhoneNumberInput(context, 3, leading,
                          next: middleNode),
                      const Text("-"),
                      buildPhoneNumberInput(context, 4, middle,
                          current: middleNode,
                          next: trailingNode,
                          autofocus: true),
                      const Text("-"),
                      buildPhoneNumberInput(context, 4, trailing,
                          current: trailingNode),
                      const VerticalDivider(
                        color: Colors.transparent,
                      ),
                      ElevatedButton(
                          onPressed: onRequest
                              ? null
                              : () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (phoneNumberFormKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      canEnterCode = false;
                                      onRequest = true;
                                    });
                                    final phoneNumber = "+82" +
                                        leading.text.substring(1) +
                                        middle.text +
                                        trailing.text;
                                    final succeed =
                                        await authBloc.requestVerificationCode(
                                            user.id, phoneNumber);
                                    if (succeed) {
                                      canEnterCode = true;
                                    }

                                    setState(() {
                                      onRequest = false;
                                    });
                                  }
                                },
                          child:
                              Text(Strings.of(context).requestVerificationCode))
                    ]),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(
                            errorText: isVerified == null || isVerified == true
                                ? null
                                : Strings.of(context).invalidCode),
                        controller: code,
                        enabled: canEnterCode,
                        autofillHints:
                            canEnterCode ? [AutofillHints.oneTimeCode] : null,
                      )),
                      ElevatedButton(
                          onPressed: onRequest || !canEnterCode
                              ? null
                              : () async {
                                  setState(() {
                                    onRequest = true;
                                  });
                                  isVerified = await authBloc.verifyIdentity(
                                      user.id, code.text);

                                  if (isVerified!) {
                                    user.isVerified = true;
                                    Navigator.of(context).pop();
                                  } else {
                                    setState(() {
                                      onRequest = false;
                                    });
                                  }
                                },
                          child: Text(Strings.of(context).verifyIdentity))
                    ],
                  )
                ],
              )),
        )),
      );

  Widget buildPhoneNumberInput(
          BuildContext context, int maxLength, TextEditingController controller,
          {FocusNode? current, FocusNode? next, bool autofocus = false}) =>
      Expanded(
        flex: maxLength,
        child: TextFormField(
          controller: controller,
          focusNode: current,
          autofocus: autofocus,
          keyboardType: TextInputType.number,
          maxLength: maxLength,
          textAlign: TextAlign.center,
          onChanged: (value) {
            if (value.length == maxLength) {
              next?.requestFocus();
            }
          },
          validator: (value) => value?.isNotEmpty != true ? "" : null,
          decoration: InputDecoration(counterText: ""),
        ),
      );
}
