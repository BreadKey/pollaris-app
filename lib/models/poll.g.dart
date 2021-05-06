// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poll _$PollFromJson(Map<String, dynamic> json) {
  return Poll(
    json['userId'] as String,
    json['question'] as String,
    (json['options'] as List<dynamic>)
        .map((e) => Option.fromJson(e as Map<String, dynamic>))
        .toList(),
    id: json['id'] as int,
    userAnswerAt: json['userAnswerAt'] as int?,
  );
}

Map<String, dynamic> _$PollToJson(Poll instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'question': instance.question,
      'options': instance.options,
      'userAnswerAt': instance.userAnswerAt,
    };

Option _$OptionFromJson(Map<String, dynamic> json) {
  return Option(
    json['pollId'] as int,
    json['index'] as int,
    json['body'] as String,
    count: json['count'] as int,
  );
}

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'pollId': instance.pollId,
      'index': instance.index,
      'body': instance.body,
      'count': instance.count,
    };
