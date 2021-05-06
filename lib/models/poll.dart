import 'package:json_annotation/json_annotation.dart';

part 'poll.g.dart';

@JsonSerializable()
class Poll {
  final int id;
  final String userId;
  final String question;
  final List<Option> options;
  int? userAnswerAt;

  Poll(this.userId, this.question, this.options,
      {this.id = 0, this.userAnswerAt});

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);
}

@JsonSerializable()
class Option {
  final int pollId;
  final int index;
  final String body;
  int count;

  Option(this.pollId, this.index, this.body, {this.count = 0});

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
}
