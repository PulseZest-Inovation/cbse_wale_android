import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.history), text: "Recent"),
            Tab(icon: Icon(Icons.star), text: "Saved"),
            Tab(icon: Icon(Icons.location_on), text: "Nearby"),
            Tab(icon: Icon(Icons.person), text: "New"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('Recent')),
          Center(child: Text('Saved')),
          Center(child: Text('Nearby')),
          Center(child: Text('New')),
        ],
      ),
    );
  }
}
