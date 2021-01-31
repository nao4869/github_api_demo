import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_api_demo/pages/home_screen.dart';
import 'package:provider/provider.dart';

import 'providers/issues_provider.dart';

void main() {
  var github = GitHub();
  var authenticatedUser = GitHub(auth: findAuthenticationFromEnvironment());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => IssueProvider(
            issues: [],
            authenticatedUser: authenticatedUser,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
