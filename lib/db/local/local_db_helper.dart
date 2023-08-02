import 'package:appscwl_specialhire/models/all_districts_model.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

const String tableDistrict = 'districtList';

class LocalDBHelper {
  static const String createTableDistrictList = '''create table $tableDistrict(
  distID text primary key,
  distTitle text
 )''';

  static Future<Database> openLocalDB() async {
    final rootPath = await getDatabasesPath();
    final dbPath = Path.join(rootPath, 'special_hire');

    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute(createTableDistrictList);
    }, onUpgrade: (db, oldVersion, newVersion) {
      //
    });
  }

  static Future<void> insertDistricts(
      AllDistrictsModel allDistrictsModel) async {
    print('data inserting');
    final _db = await openLocalDB();
    final batch = _db.batch();
    if (allDistrictsModel.districts != null) {
      for (var district in allDistrictsModel.districts!) {
        batch.insert(tableDistrict, district.toJson(),
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Districts>> fetchDistricts() async {
    print('data loading');
    final _db = await openLocalDB();
    final mapList = await _db.query(tableDistrict);
    return List.generate(
        mapList.length, (row) => Districts.fromJson(mapList[row]));
  }

  static Future<int> deleteDistricts() async {
    final _db = await openLocalDB();
    return await _db.delete(tableDistrict);
  }
}
