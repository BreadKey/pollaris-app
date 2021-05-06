import 'package:flutter/material.dart';
import 'package:pollaris_app/models/poll.dart';
import 'package:pollaris_app/models/user.dart';
import 'package:pollaris_app/screens/verify_identity_page.dart';
import 'package:provider/provider.dart';

class PollCard extends StatefulWidget {
  final Poll poll;

  const PollCard({Key? key, required this.poll}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  late bool isLong;

  @override
  void initState() {
    super.initState();

    isLong = widget.poll.options
            .map((option) => option.body.length)
            .reduce((value, element) => value + element) >
        20;
  }

  @override
  Widget build(BuildContext context) => Card(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(
                "Q. ",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Text(
                widget.poll.question,
                style: Theme.of(context).textTheme.headline6,
              )
            ]),
            const Divider(),
            Align(
                alignment: Alignment.bottomRight,
                child: Flex(
                  direction: isLong ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.poll.options
                      .map(
                        (option) => _OptionButton(option: option),
                      )
                      .toList(),
                ))
          ],
        ),
      ));
}

class _OptionButton extends StatelessWidget {
  final Option option;

  const _OptionButton({Key? key, required this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
      onPressed: () {
        final user = context.read<User>();
        if (!user.isVerified) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Provider.value(
                    value: user,
                    child: VerifyIdentityPage(),
                  )));
        }
      },
      child: Text(option.body));
}
