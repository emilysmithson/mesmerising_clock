import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

int _id;
int currentColorSelection = 0;

class ClockSettings {
  int id;
  Color backgroundColor;
  Color clockFace;
  Color secondsClockwise;
  Color secondsAnticlockwise;
  Color minutesClockwise;
  Color minutesAntiClockwise;
  Color handsColor;
  double handThickness;
  ClockSettings(
      this.id,
      this.backgroundColor,
      this.clockFace,
      this.secondsClockwise,
      this.secondsAnticlockwise,
      this.minutesClockwise,
      this.minutesAntiClockwise,
      this.handsColor,
      this.handThickness);
}

List<ClockSettings> clockSettingsList = [
  ClockSettings(
    0,
    Color(0x40aaffc3),
    Color(0xbfaaffc3),
    Color(0x80008080),
    Color(0x808b0074),
    Color(0x80ff0000),
    Color(0x80c5803a),
    Colors.black,
    1,
  )
];

List<Color> currentColor = [
  clockSettingsList[0].backgroundColor,
  clockSettingsList[0].clockFace,
  clockSettingsList[0].secondsClockwise,
  clockSettingsList[0].secondsAnticlockwise,
  clockSettingsList[0].minutesClockwise,
  clockSettingsList[0].minutesClockwise,
  clockSettingsList[0].handsColor
];

double currentHandThickness = clockSettingsList[0].handThickness;

changeColor(int i, Color color) {
  currentColor.replaceRange(i, i + 1, [color]);
}

deleteColors(int i) {
  DatabaseHelper helper = DatabaseHelper.instance;
  helper.deleteColor(clockSettingsList[i].id);
  clockSettingsList.removeAt(i);
  resetColors(0);
  saveToSP();
}

resetColors(int i) {
  currentColorSelection = i;
  saveToSP();
  currentColor.clear();
  currentColor = [
    clockSettingsList[i].backgroundColor,
    clockSettingsList[i].clockFace,
    clockSettingsList[i].secondsClockwise,
    clockSettingsList[i].secondsAnticlockwise,
    clockSettingsList[i].minutesClockwise,
    clockSettingsList[i].minutesAntiClockwise,
    clockSettingsList[i].handsColor
  ];
  currentHandThickness = clockSettingsList[i].handThickness;
}

saveCurrentSelection() {
  if (clockSettingsList.length == 10) {
    clockSettingsList.removeLast();
    DatabaseHelper helper = DatabaseHelper.instance;
    helper.deleteColor(10);
  }

  _id = clockSettingsList[(clockSettingsList.length - 1)].id + 1;
  currentColorSelection = clockSettingsList.length;
  saveToSP();
  clockSettingsList.add(ClockSettings(
      _id,
      currentColor[0],
      currentColor[1],
      currentColor[2],
      currentColor[3],
      currentColor[4],
      currentColor[5],
      currentColor[6],
      currentHandThickness));
  DatabaseHelper helper = DatabaseHelper.instance;
  helper.insertColor(clockSettingsList.length - 1);
}

class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    print('initialising db');
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    print('create db');
    await db.execute('''
              CREATE TABLE colors (
                id INTEGER PRIMARY KEY,
                backgroundColor INTEGER NOT NULL,
                clockFace INTEGER NOT NULL,
                secondsClockwise INTEGER NOT NULL,
                secondsAntiClockwise INTEGER NOT NULL,
                minutesClockwise INTEGER NOT NULL,
                minutesAntiClockwise INTEGER NOT NULL,
                handsColor INTEGER NOT NULL,
                handThickness REAL NOT NULL
              )
              ''').then((value) {
      print('adding');
      for (int i = 0; i < clockSettingsList.length; i++) {
        insert(i, db);
      }
    });
  }

  // Database helper methods:

  Future<int> insert(int i, Database db) async {
    int id = await db.insert('colors', {
      'id': clockSettingsList[i].id,
      'backgroundColor': clockSettingsList[i].backgroundColor.value,
      'clockFace': clockSettingsList[i].clockFace.value,
      'secondsClockwise': clockSettingsList[i].secondsClockwise.value,
      'secondsAntiClockwise': clockSettingsList[i].secondsAnticlockwise.value,
      'minutesClockwise': clockSettingsList[i].minutesClockwise.value,
      'minutesAntiClockwise': clockSettingsList[i].minutesAntiClockwise.value,
      'handsColor': clockSettingsList[i].handsColor.value,
      'handThickness': clockSettingsList[i].handThickness,
    });
    print(id);
    return id;
  }

  Future<int> insertColor(
    int i,
  ) async {
    final Database db = await database;
    int id = await db.insert('colors', {
      'id': clockSettingsList[i].id,
      'backgroundColor': clockSettingsList[i].backgroundColor.value,
      'clockFace': clockSettingsList[i].clockFace.value,
      'secondsClockwise': clockSettingsList[i].secondsClockwise.value,
      'secondsAntiClockwise': clockSettingsList[i].secondsAnticlockwise.value,
      'minutesClockwise': clockSettingsList[i].minutesClockwise.value,
      'minutesAntiClockwise': clockSettingsList[i].minutesAntiClockwise.value,
      'handsColor': clockSettingsList[i].handsColor.value,
      'handThickness': clockSettingsList[i].handThickness,
    });

    return id;
  }

  Future<void> deleteColor(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'colors',

      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<List<Map>> queryAllColors() async {
    Database db = await database;
    List<Map> maps = await db.query(
      'colors',
    );
    if (maps.length > 0) {
      return maps;
    }

    return null;
  }

  getUserDb() async {
    Database db = await database;
    List<Map> map = await queryAllColors().then((map) {
      if (map != null) {
        clockSettingsList.clear();

        for (int i = 0; i < map.length; i++) {
          clockSettingsList.add(ClockSettings(
            map[i]['id'],
            Color(map[i]['backgroundColor']),
            Color(map[i]['clockFace']),
            Color(map[i]['secondsClockwise']),
            Color(map[i]['secondsAntiClockwise']),
            Color(map[i]['minutesClockwise']),
            Color(map[i]['minutesAntiClockwise']),
            Color(map[i]['handsColor']),
            map[i]['handThickness'],
          ));
        }
      }
      fetchFromSP();
      return map;
    });
  }

  deleteDB() async {
    Database db = await database;
    db.delete('colors');
  }
}

saveToSP() async {
  print(currentColorSelection);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('currentColorSelection', currentColorSelection);
}

fetchFromSP() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int intValue = prefs.getInt('currentColorSelection');
  print (intValue);
  if (intValue != null) {
    resetColors(intValue);
  }
}
