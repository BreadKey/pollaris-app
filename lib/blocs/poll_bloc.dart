import 'dart:convert';

import 'package:pollaris_app/blocs/authorizer.dart';
import 'package:pollaris_app/blocs/secret.dart';
import 'package:pollaris_app/models/poll.dart';
import 'package:http/http.dart' as http;

class PollBloc {
  Future<List<Poll>> page({int from = 0, int count = 0}) async {
    final Map<String, dynamic> query = {};

    if (from > 0) {
      query["from"] = from;
    }

    if (count > 0) {
      query["count"] = count;
    }

    final response = await http.get(Uri.https(domain, "$stage/poll", query),
        headers: await authorizeUser());

    try {
      final body = json.decode(response.body);

      final result = body.map<Poll>((json) => Poll.fromJson(json)).toList();

      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
