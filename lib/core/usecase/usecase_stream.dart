import 'package:chat/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCaseStream<Success, Params> {
  Either<Failure, Stream<Success>> call(Params params);
}
