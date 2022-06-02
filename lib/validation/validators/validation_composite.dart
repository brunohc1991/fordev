import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';
import 'package:meta/meta.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) {
    String error;
    for (final validation in validations.where((item) => item.field == field)) {
      error = validation.validate(value);
      if (error?.isNotEmpty == true) {
        return error;
      }
    }

    return error;
  }
}
