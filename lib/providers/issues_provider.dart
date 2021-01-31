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

  bool _isLoading = false;
  bool get getIsLoading => _isLoading;

  // getter for post
  List<dynamic> get postList {
    return [...issues];
  }

  Future<void> retrieveIssues() async {
    if (_isLoading) {
      return;
    }

    final url =
        'https://api.github.com/repos/flutter/flutter/issues?state=open';
    var response;

    _isLoading = true;
    try {
      response = await http.get(
        url,
        headers: {"Accept": "application/vnd.github.v3+json"},
      ); // get
    } catch (error) {
      print(error);
    } // for fetching from DB

    final body = json.decode(response.body);
    final issues = body.map((dynamic item) => Issue.fromJson(item)).toList();
    this.issues = issues;
    notifyListeners();
  }
}
