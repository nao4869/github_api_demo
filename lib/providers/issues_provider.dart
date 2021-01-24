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
      final response = await http.get(url); // get for fetching from DB
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      final List<Issue> loadedIssues = [];

      extractedData.forEach((postId, issue) {
        loadedIssues.add(Issue(
          id: issue['id'],
          state: issue['state'],
          title: issue['title'],
          body: issue['body'],
          updatedAt: issue['updatedAt'],
          createdAt: issue['createdAt'],
          comments: issue['comments'],
        ));
      });
      issues = loadedIssues;

      // 作成日毎にソートする
      issues.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
