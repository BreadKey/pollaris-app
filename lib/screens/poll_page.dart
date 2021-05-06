import 'package:flutter/material.dart';
import 'package:pollaris_app/blocs/poll_bloc.dart';
import 'package:pollaris_app/models/poll.dart';
import 'package:pollaris_app/screens/poll_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PollPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PollPageState();
}

class _PollPageState extends State<PollPage>
    with AutomaticKeepAliveClientMixin {
  late PollBloc bloc;
  final polls = <Poll>[];

  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();

    bloc = PollBloc();

    refreshController = RefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SmartRefresher(
        controller: refreshController,
        onRefresh: () async {
          final polls = await bloc.page();
          setState(() {
            this.polls.clear();
            this.polls.addAll(polls);
            refreshController.refreshCompleted();
          });
        },
        child: ListView.builder(
            itemCount: polls.length,
            itemBuilder: (context, index) => PollCard(poll: polls[index])));
  }

  @override
  bool get wantKeepAlive => true;
}
