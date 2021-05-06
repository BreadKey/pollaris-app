part of my_page;

class SignOutButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignOutButtonState();
}

class _SignOutButtonState extends State<SignOutButton> {
  bool onRequest = false;
  late AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc();
  }

  @override
  Widget build(BuildContext context) => PopupMenuButton(
      enabled: !onRequest,
      icon: Icon(Icons.logout),
      onSelected: (signOut) async {
        if (signOut == true) {
          setState(() {
            onRequest = true;
          });

          await authBloc.signOut();

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AuthPage()));
        }
      },
      itemBuilder: (context) => [
            PopupMenuItem(value: true, child: Text(Strings.of(context).signOut))
          ]);
}
