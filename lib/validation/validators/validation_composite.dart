import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';
import 'package:meta/meta.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError validate({@required String field, @required String value}) {
    ValidationError error;
    for (final validation in validations.where((item) => item.field == field)) {
      error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }

    return error;
  }
}
