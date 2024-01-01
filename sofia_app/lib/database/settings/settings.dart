import 'package:floor/floor.dart';

import '../user/user.dart';

@Entity(
  tableName: 'settings',
  foreignKeys: [
    ForeignKey(
      childColumns: ['user_id'],
      parentColumns: ['id'],
      entity: User,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Settings {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(name: 'user_id')
  final int userId;

  @ColumnInfo(name: 'dark_mode')
  final bool darkMode;
  @ColumnInfo(name: 'language')
  final String language;

  @ColumnInfo(name: 'messagesfrom_smartphones')
  final bool messagesfrom_smartphones;

  @ColumnInfo(name: 'commandto_smartphones')
  final bool commandto_smartphones;

  @ColumnInfo(name: 'priority')
  final bool priority;

  Settings(
    this.id,
    this.userId,
    this.darkMode,
    this.language,
    this.messagesfrom_smartphones,
    this.commandto_smartphones,
    this.priority,
  );
}
