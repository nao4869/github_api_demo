import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_api_demo/constant/constants.dart';
import 'package:provider/provider.dart';

import '../providers/issues_provider.dart';

class HomeScreenNotifier extends ChangeNotifier {
  HomeScreenNotifier({
    this.context,
    this.vsync,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      await getIssues();
    });
    initialize();
  }

  final BuildContext context;
  final TickerProvider vsync;

  bool isLoading = false;
  TabController tabController;
  List<Tab> tabs;

  void initialize() {
    tabs = <Tab>[
      Tab(text: allLabel),
      Tab(text: webviewLabel),
      Tab(text: sharedPreferencesLabel),
      Tab(text: waitingLabel),
      Tab(text: severeLabel),
      Tab(text: shareLabel),
    ];
    tabController = TabController(
      vsync: vsync,
      length: tabs.length,
    );
  }

  Future<void> getIssues({
    String label,
  }) async {
    final notifier = Provider.of<IssueProvider>(context, listen: false);
    await notifier.retrieveIssues(label);
    isLoading = false;
    notifyListeners();
  }
}
