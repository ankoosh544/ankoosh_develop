import 'package:floor/floor.dart';

import 'user.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM user')
  Future<List<User>> getAllUsers();

  @Query('SELECT * FROM user WHERE id = :id')
  Future<User?> getUserById(int id);

  @Query('SELECT * FROM user WHERE email = :email LIMIT 1')
  Future<User?> getUserByEmail(String email);

  @Query(
      'SELECT * FROM user WHERE username = :username AND password = :password')
  Future<User?> getUserByUsername(String username, String password);

  @insert
  Future<void> registerUser(User user);

  @update
  Future<void> updateUser(User user);

  @delete
  Future<void> deleteUser(User user);
}
