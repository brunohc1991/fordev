import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/domain/entities/entities.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  SaveSecureCacheStorageSpy cacheStorage;
  LocalSaveCurrentAccount sut;
  AccountEntity account;

  void mockError() {
    when(cacheStorage.saveSecure(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

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
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
