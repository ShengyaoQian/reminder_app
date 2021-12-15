import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:reminder_app/routine_model.dart';
import 'package:reminder_app/notification_service.dart';

class ReminderAppDatabaseProvider extends ChangeNotifier {
  static String dbName = "reminder_app_db";
  static String routineTableName = "routines";

  static Future<Database> database() async {
    return openDatabase(join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $routineTableName(
           id INTEGER PRIMARY KEY NOT NULL,
           title STRING,
           starttimeUnix INTEGER,
           durationNumber INTEGER,
           unit STRING         
        )''',
        );
      },
      version: 1,
    );
  }

  // Define a function that inserts routines into the database
  Future<void> insertRoutine(Routine routine) async {
    // Get a reference to the database.
    final db = await database();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'routines',
      routine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
    NotificationService().scheduleNotifications(routine.id, routine.title, routine.durationNumber, routine.unit);
  }

  // A method that retrieves all the routines from the routines table.
  Future<List<Routine>> routines() async {
    // Get a reference to the database.
    final db = await database();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('routines');

    // Convert the List<Map<String, dynamic> into a List<Routine>.
    return List.generate(maps.length, (i) {
      return Routine(
        id: maps[i]['id'],
        title: '${maps[i]['title']}',
        starttimeUnix: maps[i]['starttimeUnix'],
        durationNumber: maps[i]['durationNumber'],
        unit: '${maps[i]['unit']}',
      );
    });
  }

  Future<void> updateRoutine(Routine routine) async {
    // Get a reference to the database.
    final db = await database();

    // Update the given Routine.
    await db.update(
      'routines',
      routine.toMap(),
      where: 'id = ?',
      whereArgs: [routine.id],
    );
    notifyListeners();
    NotificationService().cancelNotifications(routine.id);
    NotificationService().scheduleNotifications(routine.id, routine.title, routine.durationNumber, routine.unit);
  }

  Future<void> deleteRoutine(int id) async {
    // Get a reference to the database.
    final db = await database();

    // Remove the Dog from the database.
    await db.delete(
      'routines',
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
    NotificationService().cancelNotifications(id);
  }


}


