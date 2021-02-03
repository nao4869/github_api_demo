import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_api_demo/constant/constants.dart';
import 'package:github/github.dart';
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

  bool _isExcludeClosedIssues = false;
  bool _isExcludeNoUpdatedIssues = false;
  bool _isSortByCreatedAt = false;
  bool _isSortByUpdatedAt = false;
  bool _isSortByCommentsCount = false;
  bool _isUpdating = false;

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
    await notifier.retrieveIssues();
    isLoading = false;
    notifyListeners();
  }

  List<Issue> updateSortCondition(
    IssueLabelEnum type,
  ) {
    final notifier = Provider.of<IssueProvider>(context, listen: false);
    final sortedIssues = notifier.getIssuesList(
      type: type,
      isExcludeClosedIssues: _isExcludeClosedIssues,
      isExcludeNoUpdatedIssues: _isExcludeNoUpdatedIssues,
      isSortByCreatedAt: _isSortByCreatedAt,
      isSortByUpdatedAt: _isSortByUpdatedAt,
      isSortByCommentsCount: _isSortByCommentsCount,
    );
    return sortedIssues;
  }

  void showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return _buildAddTaskDialog(
              setState,
            );
          },
        );
      },
    );
  }

  /// ソート用ダイアログ
  Widget _buildAddTaskDialog(
    Function setState,
  ) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {},
          child: Column(
            children: [
              _buildCheckBoxListTile(
                title: 'Closed状態のIssueを除外する',
                checkBoxValue: _isExcludeClosedIssues,
                onChanged: (bool value) {
                  setState(() => _isExcludeClosedIssues = value);
                },
              ),
              _buildCheckBoxListTile(
                title: '1年以上更新のないIssueを除外する',
                checkBoxValue: _isExcludeNoUpdatedIssues,
                onChanged: (bool value) {
                  setState(() => _isExcludeNoUpdatedIssues = value);
                },
              ),
              _buildCheckBoxListTile(
                title: '作成日時の新しい順',
                checkBoxValue: _isSortByCreatedAt,
                onChanged: (bool value) {
                  setState(() => _isSortByCreatedAt = value);
                },
              ),
              _buildCheckBoxListTile(
                title: '更新日時の古い順',
                checkBoxValue: _isSortByUpdatedAt,
                onChanged: (bool value) {
                  setState(() => _isSortByUpdatedAt = value);
                },
              ),
              _buildCheckBoxListTile(
                title: 'コメント数の多い順',
                checkBoxValue: _isSortByCommentsCount,
                onChanged: (bool value) {
                  setState(() => _isSortByCommentsCount = value);
                },
              ),
              SizedBox(
                width: 250,
                child: _buildRaisedButton(
                  title: '設定',
                  onPressed: () {
                    Navigator.of(context).pop();
                    updateSortCondition(IssueLabelEnum.allIssues);
                    notifyListeners();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckBoxListTile({
    String title,
    bool checkBoxValue,
    Function onChanged,
  }) {
    return CheckboxListTile(
      value: checkBoxValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildRaisedButton({
    @required String title,
    @required VoidCallback onPressed,
  }) {
    return RaisedButton(
      color: Colors.blue,
      elevation: 0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
