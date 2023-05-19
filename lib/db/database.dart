// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/person_dao.dart';
import 'entity/person.dart';


part 'database.g.dart';

@Database(version: 1, entities: [Person])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;

  static AppDatabase? instance;

  static Future<void> init() async {
    instance =
        await $FloorAppDatabase.databaseBuilder('floor_database.db').build();
  }
}
