import 'package:flutter/material.dart';
import 'package:github_api_demo/pages/home_screen_notifier.dart';
import 'package:github_api_demo/providers/issues_provider.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = 'home-screen';

  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return VsyncProvider(
      isSingleTicker: true,
      child: ChangeNotifierProvider(
        create: (context) => HomeScreenNotifier(
          context: context,
          vsync: VsyncProvider.of(context),
        ),
        child: _HomeScreen(),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<HomeScreenNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TabBar(
              tabs: notifier.tabs,
              controller: notifier.tabController,
            )
          ],
        ),
      ),
      body: notifier.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: notifier.tabController,
              children: notifier.tabs.map((Tab tab) {
                return _buildAllIssues(context);
              }).toList(),
            ),
    );
  }

  Widget _buildAllIssues(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final issuesNotifier = Provider.of<IssueProvider>(context);
    return SingleChildScrollView(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: issuesNotifier.issues.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              SizedBox(
                width: size.width * .8,
                height: size.width * .4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Card(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            Text(
                              'No. ' +
                                  issuesNotifier.issues[index].number
                                      .toString(),
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            issuesNotifier.issues[index].title.toString(),
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Text(
                                issuesNotifier.issues[index].body.toString(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
