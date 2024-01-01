import 'package:floor/floor.dart';

@Entity(tableName: 'user')
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String email;

  final String username;

  final String password;

  @ColumnInfo(name: 'remember_me')
  final bool rememberMe;

  User(
    this.id,
    this.email,
    this.username,
    this.password,
    this.rememberMe,
  );
}
