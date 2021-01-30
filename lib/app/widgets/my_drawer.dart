import 'package:flutter/material.dart';
import '../blocs/bloc.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, 
        children: <Widget>[
          DrawerHeader(
            child: Text('Hallo'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Mehr Information', style: TextStyle(color: Theme.of(context).primaryColor)),
            trailing: Icon(Icons.info, color: Theme.of(context).primaryColor),
            onTap: () => Navigator.pushNamed(context, '/info'),
            ),
          ListTile(
            title: Text('Meine Räume entfernen', style: TextStyle(color: Theme.of(context).primaryColor)),
            trailing: Icon(Icons.delete_sweep, color: Theme.of(context).primaryColor),
            onTap: () => Navigator.pushNamed(context, '/reset'),
          ),
          StreamBuilder<bool>(
              stream: bloc.fcmAllowed,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return _buildNotificationListTile(context, snapshot.data ?? false);
              },
          ),
          Divider(),
          ListTile(
            title: Text('Abmelden', style: TextStyle(color: Theme.of(context).primaryColor)),
            trailing: Icon(Icons.power_settings_new, color: Theme.of(context).primaryColor),
            onTap: () {
              bloc.signOut();
              Navigator.pushNamed(context, '/signin');
             }
          ),
        ],
      ),
    );
  }

  ListTile _buildNotificationListTile(BuildContext context, bool isNotificationAllowed) {
    print('(TRACE) Notifications allowed: $isNotificationAllowed');
    if (!isNotificationAllowed) {
      return ListTile(
        title: Text('Mitteilungen abonnieren', style: TextStyle(color: Theme.of(context).primaryColor)),
        trailing: Icon(Icons.speaker_notes, color: Theme.of(context).primaryColor),
        onTap: () async {
          await bloc.allowNotifications();
          Navigator.pop(context);
        },
      );
    } else {
        return ListTile(
          title: Text('Mitteilungen abbestellen', style: TextStyle(color: Theme.of(context).primaryColor)),
          trailing: Icon(Icons.speaker_notes_off, color: Theme.of(context).primaryColor),
          onTap: () async {
            await bloc.blockNotifications();
            Navigator.pop(context);
          },
        );
    }
  }
}
