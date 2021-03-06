import 'package:github_api_demo/models/label.dart';
import 'dart:convert';

class Issue {
  final int id;
  final String nodeId;
  final String url;
  final String repositoryUrl;
  final String labelsUrl;
  final String commentsUrl;
  final String eventsUrl;
  final String htmlUrl;
  final int number;
  final int comments;

  final String state;
  final String title;
  final String body;
  final String createdAt;
  final String updatedAt;
  final List<Label> labels;

  Issue({
    this.id,
    this.nodeId,
    this.url,
    this.repositoryUrl,
    this.labelsUrl,
    this.commentsUrl,
    this.eventsUrl,
    this.htmlUrl,
    this.number,
    this.state,
    this.title,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.comments,
    this.labels,
  });

  // static fromJson(json) {
  //   List<Map<String, Object>> issuesList = json.decode(json);

  //   return issuesList.map((issue) {
  //     final issueInstance = Issue();
  //     issueInstance.id = issue['id'];
  //     issueInstance.title = issue['title'];
  //     issueInstance.starCount = item['stargazers_count'];
  //     return issueInstance;
  //   }).toList();
  // }
}
