import 'package:floor/floor.dart';

import '../user/user.dart';

@Entity(
  tableName: 'rides',
  foreignKeys: [
    ForeignKey(
      childColumns: ['user_id'],
      parentColumns: ['id'],
      entity: User,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Rides {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'user_id')
  final int userId;

  @ColumnInfo(name: 'evelator_id')
  final String elevatorId;

  //@ColumnInfo(name: 'date')
  //final DateTime date;

  @ColumnInfo(name: 'start_floor')
  final int startFloor;

  @ColumnInfo(name: 'target_floor')
  final int targetFloor;
  Rides(
    this.id,
    this.userId,
    this.elevatorId,
    //this.date,
    this.startFloor,
    this.targetFloor,
  );
}
