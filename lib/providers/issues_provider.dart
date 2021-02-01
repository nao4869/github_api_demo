import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:http/http.dart' as http;

enum Issues {
  allIssues,
  webViewIssues,
  sharedIssues,
  waitingIssues,
  severeIssues,
  shareIssues,
}

class IssueProvider with ChangeNotifier {
  IssueProvider({
    this.allIssues = const [],
    this.webViewIssues = const [],
    this.sharedIssues = const [],
    this.waitingIssues = const [],
    this.severeIssues = const [],
    this.shareIssues = const [],
  });

  List<dynamic> allIssues = [];
  List<dynamic> webViewIssues = [];
  List<dynamic> sharedIssues = [];
  List<dynamic> waitingIssues = [];
  List<dynamic> severeIssues = [];
  List<dynamic> shareIssues = [];

  List<dynamic> getIssuesList(Issues type) {
    switch (type) {
      case Issues.webViewIssues:
        return webViewIssues;
      case Issues.sharedIssues:
        return sharedIssues;
      case Issues.waitingIssues:
        return waitingIssues;
      case Issues.severeIssues:
        return severeIssues;
      case Issues.shareIssues:
        return shareIssues;
      default:
        return allIssues;
    }
  }

  Future<void> retrieveIssues(
    String label,
  ) async {
    String url;
    if (label == null) {
      url = 'https://api.github.com/repos/flutter/flutter/issues';
    } else {
      url = 'https://api.github.com/repos/flutter/flutter/issues?labels=$label';
    }

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
    allIssues = issues;
    notifyListeners();
  }
}
