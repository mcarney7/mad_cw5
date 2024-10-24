import 'dart:convert';
import 'dart:ui'; // For Offset
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'fish.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('aquarium.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE fish (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        speed REAL,
        position TEXT,
        imagePath TEXT
      )
    ''');
  }

  Future<void> saveFish(List<Fish> fishList) async {
    final db = await instance.database;
    await db.delete('fish');

    for (var fish in fishList) {
      await db.insert('fish', {
        'name': fish.name,
        'speed': fish.speed,
        'position': jsonEncode({'dx': fish.position.dx, 'dy': fish.position.dy}),
        'imagePath': fish.imagePath,
      });
    }
  }

  Future<List<Fish>> loadFish() async {
    final db = await instance.database;
    final fishData = await db.query('fish');

    List<Fish> loadedFish = fishData.map<Fish>((data) {
      var position = jsonDecode(data['position'] as String);
      return Fish(
        name: data['name'] as String,
        speed: data['speed'] as double,
        position: Offset(position['dx'], position['dy']),
        imagePath: data['imagePath'] as String,
      );
    }).toList();

    return loadedFish;
  }
}

