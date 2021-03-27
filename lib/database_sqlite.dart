
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'campuspost.db'),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE myFriends(num INTEGER PRIMARY KEY, email TEXT)");
        // await db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");

        return db;
      },
      version: 1,
    );
  }


  Future<List<String>> getMyFriends() async {
    Database _db = await database();
    List<Map<String, dynamic>> friendMap = await _db.query('myFriends');
    return List.generate(friendMap.length, (index) {
      return friendMap[index]['email'];
    });
  }

  Future<void> insertFriend(String email, int numPlus) async {
    int num = 0;
    Database _db = await database();
    await _db.insert('myFriends', {'num': numPlus,'email': email}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteFriend(String email) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM myFriends WHERE email = '$email'");
  }


}