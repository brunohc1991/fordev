import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/validation/protocols/protocols.dart';
import 'package:fordev/validation/validators/validators.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  FieldValidationSpy validation001;
  FieldValidationSpy validation002;
  FieldValidationSpy validation003;
  ValidationComposite sut;

  void mockValidation1(String error) {
    when(validation001.validate(any)).thenReturn(error);
  }

  void mockValidation2(String error) {
    when(validation002.validate(any)).thenReturn(error);
  }

  void mockValidation3(String error) {
    when(validation003.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation001 = FieldValidationSpy();
    validation002 = FieldValidationSpy();
    validation003 = FieldValidationSpy();

    when(validation001.field).thenReturn('other_field');
    mockValidation1(null);

    when(validation002.field).thenReturn('any_field');
    mockValidation2(null);

    when(validation003.field).thenReturn('any_field');
    mockValidation3(null);

    sut = ValidationComposite([validation001, validation002, validation003]);
  });

  test('Should return null iff all validations returns null or empty', () {
    mockValidation2('');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });

  test('Should return the first error', () {
    mockValidation1('Error_001');
    mockValidation2('Error_002');
    mockValidation3('Error_003');

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, 'Error_002');
  });
}