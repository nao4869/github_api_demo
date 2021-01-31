import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_api_demo/models/issue.dart';
import 'package:http/http.dart' as http;

class IssueProvider with ChangeNotifier {
  List<Issue> issues = [];

  IssueProvider({
    this.issues,
  });

  // getter for post
  List<Issue> get postList {
    return [...issues];
  }

  Future<void> retrieveIssues() async {
    final url = 'https://api.github.com/issues';
    try {
      final response = await http.get(
        url,
        headers: {"Accept": "application/json"},
      ); // get for fetching from DB
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      final List<Issue> loadedIssues = [];

      extractedData.forEach((issueId, issue) {
        // loadedIssues.add(
        //   Issue(
        //     //id: issue['id'],
        //     //state: issue['state'],
        //     title: issue["title"],
        //     // body: issue['body'],
        //     // updatedAt: issue['updatedAt'],
        //     // createdAt: issue['createdAt'],
        //     // number: issue['number'],
        //   ),
        // );
      });
      issues = loadedIssues;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
