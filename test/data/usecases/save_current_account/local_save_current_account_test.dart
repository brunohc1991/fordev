import 'package:faker/faker.dart';
import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:fordev/domain/entities/entities.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});

  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(
          key: 'token', value: account.token);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({String key, String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  SaveSecureCacheStorageSpy cacheStorage;
  LocalSaveCurrentAccount sut;
  AccountEntity account;

  setUp(() {
    cacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: cacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(cacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test('Should throw Unexpected error if SaveSecureCacheStorage throws',
      () async {
    when(cacheStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
