import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/issues_provider.dart';

class HomeScreenNotifier extends ChangeNotifier {
  HomeScreenNotifier({
    this.context,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      await getIssues();
    });
  }

  final BuildContext context;
  bool isLoading = false;

  Future<void> getIssues() async {
    final notifier = Provider.of<IssueProvider>(context, listen: false);
    await notifier.retrieveIssues();
    isLoading = false;
    notifyListeners();
  }
}
