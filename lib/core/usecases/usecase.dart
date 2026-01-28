import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Base UseCase that all usecases should extend
/// Type: The return type (e.g., List<Product>)
/// Params: The input parameters
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// For usecases that don't need parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
