import 'package:fordev/presentation/protocols/protocols.dart';
import 'package:fordev/validation/protocols/protocols.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) {
    return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  test('Should return null iff all validations returns null or empty', () {
    final validation001 = FieldValidationSpy();
    when(validation001.field).thenReturn('any_field');
    when(validation001.validate(any)).thenReturn(null);

    final validation002 = FieldValidationSpy();
    when(validation002.field).thenReturn('any_field');
    when(validation002.validate(any)).thenReturn('');

    final sut = ValidationComposite([validation001, validation002]);

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}
