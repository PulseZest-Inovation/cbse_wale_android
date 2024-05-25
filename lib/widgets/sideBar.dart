import 'package:flutter/material.dart';

import '../logout/logoutFxn.dart';

class SideBar extends StatelessWidget {
  // final Function onProfilePressed;
  // final Function onDownloadsPressed;
  // final Function onInfoPressed;
  // final Function onSupportPressed;
  // final Function onVersionPressed;

  const SideBar({
    Key? key,
    // required this.onProfilePressed,
    // required this.onDownloadsPressed,
    // required this.onInfoPressed,
    // required this.onSupportPressed,
    // required this.onVersionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Ashish'),
            accountEmail: Text('ashish@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/icons/google.png'),
            ),
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Profile Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.download),
            title: Text('Downloads'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Downloads Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Info'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Info Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.support),
            title: Text('Support'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Support Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              LogoutFxn.logout(context);
            },
          ),
          Divider(),
          Spacer(),
          Text("version 1.0.0"),
          Text("Made By Pulsezest❤️"),
          SizedBox(height: 19), // Add some spacing at the bottom
        ],
      ),
    );
  }
}
//
// import 'package:flutter/material.dart';
//
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Drawer Demo'),
//       ),
//       drawer: Drawer(
//         child: Column(
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               accountName: Text('Ashish'),
//               accountEmail: Text('ashish@example.com'),
//               currentAccountPicture: CircleAvatar(
//                 backgroundImage: AssetImage('assets/profile.jpg'),
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profile'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to Profile Screen
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.download),
//               title: Text('Downloads'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to Downloads Screen
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.info),
//               title: Text('Info'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to Info Screen
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.support),
//               title: Text('Support'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to Support Screen
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Handle logout
//               },
//             ),
//             Divider(),
//             Spacer(),
//             Text("version 1.0.0"),
//             Text("Made By Pulsezest❤️"),
//             SizedBox(height: 19), // Add some spacing at the bottom
//           ],
//         ),
//       ),
//       body: Center(
//         child: Text('Swipe from left .'),
//       ),
//     );
//   }
// }
