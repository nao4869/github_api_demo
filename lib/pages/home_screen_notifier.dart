import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/issues_provider.dart';

class HomeScreenNotifier extends ChangeNotifier {
  HomeScreenNotifier({
    this.context,
    this.vsync,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      await getIssues('all');
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
      Tab(text: '全て'),
      Tab(text: 'webview'),
      Tab(text: 'shared_preferences'),
      Tab(text: 'waiting for customer response'),
      Tab(text: 'severe: new feature'),
      Tab(text: 'share'),
    ];
    tabController = TabController(
      vsync: vsync,
      length: tabs.length,
    );
  }

  Future<void> getIssues(
    String label,
  ) async {
    final notifier = Provider.of<IssueProvider>(context, listen: false);
    await notifier.retrieveIssues(label);
    isLoading = false;
    notifyListeners();
  }
}
