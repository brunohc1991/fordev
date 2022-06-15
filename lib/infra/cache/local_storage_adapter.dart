import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import '../../data/cache/cache.dart';
import 'package:meta/meta.dart';

class LocalStorageAdapter
    implements SaveSecureCacheStorage, FetchSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({@required this.secureStorage});

  Future<void> saveSecure(
      {@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String> fetchSecure(String key) async {
    return await secureStorage.read(key: key);
  }
}
