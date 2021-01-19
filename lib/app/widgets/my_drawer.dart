import 'package:flutter/material.dart';

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
            title: Text('Einstellungen', style: TextStyle(color: Theme.of(context).primaryColor)),
            trailing: Icon(Icons.settings, color: Theme.of(context).primaryColor),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          ListTile(
            title: Text('Meine Räume entfernen', style: TextStyle(color: Theme.of(context).primaryColor)),
            trailing: Icon(Icons.delete_sweep, color: Theme.of(context).primaryColor),
            onTap: () => Navigator.pushNamed(context, '/reset'),
          ),
        ],
      ),
    );
  }
}
