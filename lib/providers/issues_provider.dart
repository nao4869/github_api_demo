import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:http/http.dart' as http;

enum IssueLabelEnum {
  allIssues,
  webViewIssues,
  sharedIssues,
  waitingIssues,
  severeIssues,
  shareIssues,
}

class IssueProvider with ChangeNotifier {
  IssueProvider({
    this.allIssues,
    this.webViewIssues,
    this.sharedIssues,
    this.waitingIssues,
    this.severeIssues,
    this.shareIssues,
  });

  List<Issue> allIssues = [];
  List<Issue> webViewIssues = [];
  List<Issue> sharedIssues = [];
  List<Issue> waitingIssues = [];
  List<Issue> severeIssues = [];
  List<Issue> shareIssues = [];

  List<dynamic> getIssuesList(IssueLabelEnum type) {
    switch (type) {
      case IssueLabelEnum.webViewIssues:
        if (webViewIssues == null || webViewIssues.isEmpty) {
          getSelectedLabelIssues('p: webview', webViewIssues);
        }
        return webViewIssues;
      case IssueLabelEnum.sharedIssues:
        if (sharedIssues == null || sharedIssues.isEmpty) {
          getSelectedLabelIssues('p: shared_preferences', sharedIssues);
        }
        return sharedIssues;
      case IssueLabelEnum.waitingIssues:
        if (waitingIssues == null || waitingIssues.isEmpty) {
          getSelectedLabelIssues(
              'waiting for customer response', waitingIssues);
        }
        return waitingIssues;
      case IssueLabelEnum.severeIssues:
        if (severeIssues == null || severeIssues.isEmpty) {
          getSelectedLabelIssues('severe: new feature', severeIssues);
        }
        return severeIssues;
      case IssueLabelEnum.shareIssues:
        if (shareIssues == null || shareIssues.isEmpty) {
          getSelectedLabelIssues('p: share', shareIssues);
        }
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

    final List<Issue> issuesList = ((json.decode(response.body) as List)
        .map((i) => Issue.fromJson(i))
        .toList());
    allIssues = issuesList;
    notifyListeners();
  }

  void getSelectedLabelIssues(
    String labelName,
    List<Issue> selectedIssuesList,
  ) {
    allIssues?.asMap()?.forEach((key, issue) {
      issue?.labels?.asMap()?.forEach((key, value) {
        if (value.name == labelName) {
          selectedIssuesList.add(issue);
        }
      });
    });
  }
}
