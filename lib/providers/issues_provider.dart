import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:http/http.dart' as http;

class IssueProvider with ChangeNotifier {
  List<dynamic> issues = [];
  final GitHub authenticatedUser;

  IssueProvider({
    this.issues,
    this.authenticatedUser,
  });

  // getter for post
  List<dynamic> get postList {
    return [...issues];
  }

  Future<void> retrieveIssues() async {
    final url =
        'https://api.github.com/repos/flutter/flutter/issues?state=open';
    var response;

    try {
      response = await http.get(
        url,
        headers: {"Accept": "application/vnd.github.v3+json"},
      ); // get
    } catch (error) {
      print(error);
    }

    final body = json.decode(response.body);
    final issues = body.map((dynamic item) => Issue.fromJson(item)).toList();
    this.issues = issues;
    notifyListeners();
  }
}
