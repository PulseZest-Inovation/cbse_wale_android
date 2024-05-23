import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile '),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 50,
                  // Add an image or background color here
                ),
              ),
              SizedBox(height: 20), // Add some spacing
              TabBar(
                tabs: [
                  Tab(text: "Info"),
                  Tab(text: "My Course"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(height: 16.0),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Name'),
                            subtitle: Text('Harshit Patel'), // Replace with your email
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text('Email'),
                            subtitle: Text('user@example.com'), // Replace with your email
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('Phone Number'),
                            subtitle: Text('+1234567890'), // Replace with your phone number
                          ),
                          Spacer(),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle logout logic here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Logged out')),
                                );
                              },
                              child: Text('Logout'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                    Container(
                      child: Text("My course Container show here"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

