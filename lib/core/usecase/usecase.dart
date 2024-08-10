import 'package:fpdart/fpdart.dart';

import '../failure/failure.dart';

abstract interface class UseCase<SuccessType, Parms> {
  Future<Either<Failure, SuccessType>> call(Parms parm);
}
