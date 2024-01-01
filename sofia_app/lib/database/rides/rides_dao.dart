import 'package:floor/floor.dart';
import 'package:sofia_app/database/rides/rides.dart';

@dao
abstract class RidesDao {
  @Query('SELECT * FROM rides')
  Future<List<Rides>?> getRides();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRides(Rides rides);
}
