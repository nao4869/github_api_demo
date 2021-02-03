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
    @required this.allIssues,
    @required this.webViewIssues,
    @required this.sharedIssues,
    @required this.waitingIssues,
    @required this.severeIssues,
    @required this.shareIssues,
  });

  List<Issue> allIssues = [];
  List<Issue> webViewIssues = [];
  List<Issue> sharedIssues = [];
  List<Issue> waitingIssues = [];
  List<Issue> severeIssues = [];
  List<Issue> shareIssues = [];

  List<Issue> getIssuesList({
    @required IssueLabelEnum type,
    bool isExcludeClosedIssues = false,
    bool isExcludeNoUpdatedIssues = false,
    bool isSortByUpdatedAt = false,
    bool isSortByCreatedAt = false,
    bool isSortByCommentsCount = false,
  }) {
    switch (type) {
      case IssueLabelEnum.webViewIssues:
        if (webViewIssues == null || webViewIssues.isEmpty) {
          getSelectedLabelIssues(
            'p: webview',
            webViewIssues,
            isSortByCreatedAt: isSortByCreatedAt,
            isSortByUpdatedAt: isSortByUpdatedAt,
            isExcludeClosedIssues: isExcludeClosedIssues,
            isExcludeNoUpdatedIssues: isExcludeNoUpdatedIssues,
            isSortByCommentsCount: isSortByCommentsCount,
          );
        }
        return webViewIssues;
      case IssueLabelEnum.sharedIssues:
        getSelectedLabelIssues(
          'p: shared_preferences',
          sharedIssues,
          isSortByCreatedAt: isSortByCreatedAt,
          isSortByUpdatedAt: isSortByUpdatedAt,
          isExcludeClosedIssues: isExcludeClosedIssues,
          isExcludeNoUpdatedIssues: isExcludeNoUpdatedIssues,
          isSortByCommentsCount: isSortByCommentsCount,
        );
        return sharedIssues;
      case IssueLabelEnum.waitingIssues:
        getSelectedLabelIssues(
          'waiting for customer response',
          waitingIssues,
          isSortByCreatedAt: isSortByCreatedAt,
          isSortByUpdatedAt: isSortByUpdatedAt,
          isExcludeClosedIssues: isExcludeClosedIssues,
          isExcludeNoUpdatedIssues: isExcludeNoUpdatedIssues,
          isSortByCommentsCount: isSortByCommentsCount,
        );
        return waitingIssues;
      case IssueLabelEnum.severeIssues:
        getSelectedLabelIssues(
          'severe: new feature',
          severeIssues,
          isSortByCreatedAt: isSortByCreatedAt,
          isSortByUpdatedAt: isSortByUpdatedAt,
          isExcludeClosedIssues: isExcludeClosedIssues,
          isExcludeNoUpdatedIssues: isExcludeNoUpdatedIssues,
          isSortByCommentsCount: isSortByCommentsCount,
        );
        return severeIssues;
      case IssueLabelEnum.shareIssues:
        getSelectedLabelIssues(
          'p: share',
          shareIssues,
          isSortByCreatedAt: isSortByCreatedAt,
          isSortByUpdatedAt: isSortByUpdatedAt,
          isExcludeClosedIssues: isExcludeClosedIssues,
          isExcludeNoUpdatedIssues: isExcludeNoUpdatedIssues,
          isSortByCommentsCount: isSortByCommentsCount,
        );
        return shareIssues;
      default:
        getSelectedLabelIssues(
          'all',
          allIssues,
          isSortByCreatedAt: isSortByCreatedAt,
          isSortByUpdatedAt: isSortByUpdatedAt,
          isExcludeClosedIssues: isExcludeClosedIssues,
          isExcludeNoUpdatedIssues: isExcludeNoUpdatedIssues,
          isSortByCommentsCount: isSortByCommentsCount,
        );
        return allIssues;
    }
  }

  Future<void> retrieveIssues() async {
    final url = 'https://api.github.com/repos/flutter/flutter/issues';

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
    List<Issue> selectedIssuesList, {
    bool isExcludeClosedIssues = false,
    bool isExcludeNoUpdatedIssues = false,
    bool isSortByCreatedAt = false,
    bool isSortByUpdatedAt = false,
    bool isSortByCommentsCount = false,
  }) {
    allIssues?.asMap()?.forEach((key, issue) {
      issue?.labels?.asMap()?.forEach((key, value) {
        if (value.name == labelName) {
          selectedIssuesList.add(issue);
        }
      });
    });
    sortByCreatedAt(
      selectedIssuesList,
      isSortByCreatedAt: isSortByCreatedAt,
    );
    sortByUpdatedAt(
      selectedIssuesList,
      isSortByUpdatedAt: isSortByUpdatedAt,
    );
    sortByCommentsCount(
      selectedIssuesList,
      isSortByCommentsCount: isSortByCommentsCount,
    );

    if (isExcludeClosedIssues) {
      excludeClosedIssues(selectedIssuesList);
    }
    if (isExcludeNoUpdatedIssues) {
      excludeNoUpdatedIssues(selectedIssuesList);
    }
  }

  void sortByCreatedAt(
    List<Issue> selectedIssuesList, {
    bool isSortByCreatedAt = false,
  }) {
    if (isSortByCreatedAt) {
      selectedIssuesList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      selectedIssuesList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
  }

  void sortByUpdatedAt(
    List<Issue> selectedIssuesList, {
    bool isSortByUpdatedAt = false,
  }) {
    if (isSortByUpdatedAt) {
      selectedIssuesList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } else {
      selectedIssuesList.sort((a, b) => a.updatedAt.compareTo(a.updatedAt));
    }
  }

  void sortByCommentsCount(
    List<Issue> selectedIssuesList, {
    bool isSortByCommentsCount = false,
  }) {
    if (isSortByCommentsCount) {
      selectedIssuesList
          .sort((a, b) => b.commentsCount.compareTo(a.commentsCount));
    } else {
      selectedIssuesList
          .sort((a, b) => a.commentsCount.compareTo(a.commentsCount));
    }
  }

  void excludeClosedIssues(
    List<Issue> selectedIssuesList, {
    bool isExcludeClosedIssues = false,
  }) {
    selectedIssuesList.removeWhere((element) => element.state == 'close');
  }

  void excludeNoUpdatedIssues(
    List<Issue> selectedIssuesList, {
    bool isExcludeNoUpdatedIssues = false,
  }) {
    selectedIssuesList.removeWhere((element) => element.state == 'close');
  }
}
