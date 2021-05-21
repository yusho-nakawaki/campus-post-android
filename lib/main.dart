import 'package:campuspost/auth_root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_file.dart';

//mainだみょーーーん
void main() {
  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // エラー時に表示するWidget
        if (snapshot.hasError) {
          return Container(color: Colors.white);
        }

        // Firebaseのinitialize完了したら表示したいWidget
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: "CampusPost",
            debugShowCheckedModeBanner: false,  // <- Debug の 表示を OFF
            theme: ThemeData(
              primaryColor: Colors.blue[900],
            ),
            home: AuthRootWidget(),
          );
        }

        // Firebaseのinitializeが完了するのを待つ間に表示するWidget
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
