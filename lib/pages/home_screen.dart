import 'package:flutter/material.dart';
import 'package:github_api_demo/pages/home_screen_notifier.dart';
import 'package:github_api_demo/providers/issues_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = 'home-screen';

  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeScreenNotifier(
        context: context,
      ),
      child: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<HomeScreenNotifier>(context, listen: false);
    final issuesNotifier = Provider.of<IssueProvider>(context, listen: false);
    notifier.getIssues();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: issuesNotifier.issues.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Text(
                  issuesNotifier.issues.toString(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
