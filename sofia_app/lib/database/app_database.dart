import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sofia_app/database/rides/rides_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'rides/rides.dart';
import 'settings/settings.dart';
import 'settings/settings_dao.dart';
import 'user/user.dart';
import 'user/user_dao.dart';

part 'app_database.g.dart'; // Generated code will be in this file

@Database(version: 1, entities: [User, Settings, Rides])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  SettingsDao get settingsDao;
  RidesDao get ridesDao;
}

class SofiaDatabase {
  static final SofiaDatabase _singleton = SofiaDatabase._internal();

  factory SofiaDatabase() {
    return _singleton;
  }

  SofiaDatabase._internal();

  static Future<AppDatabase> initDatabase() async =>
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  static Future<UserDao> get userDao async => (await initDatabase()).userDao;

  static Future<SettingsDao> get settingsDao async =>
      (await initDatabase()).settingsDao;

  static Future<RidesDao> get ridesDao async => (await initDatabase()).ridesDao;
}
