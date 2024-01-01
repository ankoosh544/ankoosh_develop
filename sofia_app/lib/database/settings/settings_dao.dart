import 'package:floor/floor.dart';

import 'settings.dart';

@dao
abstract class SettingsDao {
  @Query('SELECT * FROM settings WHERE userId = :userId')
  Future<Settings?> getSettingsByUserId(int userId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSettings(Settings settings);
}
