// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  SettingsDao? _settingsDaoInstance;

  RidesDao? _ridesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `email` TEXT NOT NULL, `username` TEXT NOT NULL, `password` TEXT NOT NULL, `remember_me` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `settings` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `user_id` INTEGER NOT NULL, `dark_mode` INTEGER NOT NULL, `language` TEXT NOT NULL, `messagesfrom_smartphones` INTEGER NOT NULL, `commandto_smartphones` INTEGER NOT NULL, `priority` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `rides` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user_id` INTEGER NOT NULL, `evelator_id` TEXT NOT NULL, `start_floor` INTEGER NOT NULL, `target_floor` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  SettingsDao get settingsDao {
    return _settingsDaoInstance ??= _$SettingsDao(database, changeListener);
  }

  @override
  RidesDao get ridesDao {
    return _ridesDaoInstance ??= _$RidesDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'user',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'username': item.username,
                  'password': item.password,
                  'remember_me': item.rememberMe ? 1 : 0
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'user',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'username': item.username,
                  'password': item.password,
                  'remember_me': item.rememberMe ? 1 : 0
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'user',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'username': item.username,
                  'password': item.password,
                  'remember_me': item.rememberMe ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM user',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['email'] as String,
            row['username'] as String,
            row['password'] as String,
            (row['remember_me'] as int) != 0));
  }

  @override
  Future<User?> getUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM user WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['email'] as String,
            row['username'] as String,
            row['password'] as String,
            (row['remember_me'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM user WHERE email = ?1',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['email'] as String,
            row['username'] as String,
            row['password'] as String,
            (row['remember_me'] as int) != 0),
        arguments: [email]);
  }

  @override
  Future<User?> getUserByUsername(
    String username,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM user WHERE username = ?1 AND password = ?2 LIMIT 1',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['email'] as String,
            row['username'] as String,
            row['password'] as String,
            (row['remember_me'] as int) != 0),
        arguments: [username, password]);
  }

  @override
  Future<void> registerUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$SettingsDao extends SettingsDao {
  _$SettingsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _settingsInsertionAdapter = InsertionAdapter(
            database,
            'settings',
            (Settings item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'dark_mode': item.darkMode ? 1 : 0,
                  'language': item.language,
                  'messagesfrom_smartphones':
                      item.messagesfrom_smartphones ? 1 : 0,
                  'commandto_smartphones': item.commandto_smartphones ? 1 : 0,
                  'priority': item.priority ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Settings> _settingsInsertionAdapter;

  @override
  Future<Settings?> getSettingsByUserId(int userId) async {
    return _queryAdapter.query('SELECT * FROM settings WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Settings(
            row['id'] as int,
            row['user_id'] as int,
            (row['dark_mode'] as int) != 0,
            row['language'] as String,
            (row['messagesfrom_smartphones'] as int) != 0,
            (row['commandto_smartphones'] as int) != 0,
            (row['priority'] as int) != 0),
        arguments: [userId]);
  }

  @override
  Future<void> insertSettings(Settings settings) async {
    await _settingsInsertionAdapter.insert(
        settings, OnConflictStrategy.replace);
  }
}

class _$RidesDao extends RidesDao {
  _$RidesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _ridesInsertionAdapter = InsertionAdapter(
            database,
            'rides',
            (Rides item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'evelator_id': item.elevatorId,
                  'start_floor': item.startFloor,
                  'target_floor': item.targetFloor
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Rides> _ridesInsertionAdapter;

  @override
  Future<List<Rides>?> getRides() async {
    return _queryAdapter.queryList('SELECT * FROM rides',
        mapper: (Map<String, Object?> row) => Rides(
            row['id'] as int?,
            row['user_id'] as int,
            row['evelator_id'] as String,
            row['start_floor'] as int,
            row['target_floor'] as int));
  }

  @override
  Future<void> insertRides(Rides rides) async {
    await _ridesInsertionAdapter.insert(rides, OnConflictStrategy.replace);
  }
}
