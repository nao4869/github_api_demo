import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/issues_provider.dart';

class HomeScreenNotifier extends ChangeNotifier {
  HomeScreenNotifier({
    this.context,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getIssues();
    });
  }

  final BuildContext context;

  void getIssues() async {
    final notifier = Provider.of<IssueProvider>(context, listen: false);
    await notifier.retrieveIssues();
    notifyListeners();
  }
}
