import 'package:chat/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCaseSync<Success, Param> {
  Either<Failure, Success> call(Param param);
}
