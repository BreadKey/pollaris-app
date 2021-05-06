library my_page;

import 'package:flutter/material.dart';
import 'package:pollaris_app/blocs/auth_bloc.dart';
import 'package:pollaris_app/models/user.dart';
import 'package:pollaris_app/screens/auth_page.dart';
import 'package:pollaris_app/screens/strings.dart';
import 'package:pollaris_app/screens/verify_identity_page.dart';
import 'package:provider/provider.dart';

part 'my_page/sign_out_button.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = context.read<User>();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("Hello, ${user.nickname}!"),
          actions: [SignOutButton()],
        ),
        body: Column(
          children: [
            Expanded(
              child: user.isVerified
                  ? ListView.builder(
                      itemCount: 0,
                      itemBuilder: (context, index) => SizedBox.shrink(),
                    )
                  : Center(
                      child: ElevatedButton(
                        child: Text(Strings.of(context).verifyIdentity),
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Provider.value(
                              value: user,
                              child: VerifyIdentityPage(),
                            ),
                          ));

                          setState(() {});
                        },
                      ),
                    ),
            )
          ],
        ),
      );
}
