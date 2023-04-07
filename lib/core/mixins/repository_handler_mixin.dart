import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tuplive/core/errors/exceptions.dart';

mixin RepositoryHandlerMixin {
  Future<Either<FailureType, ReturnType>> call<FailureType, ReturnType>({
    required Future<ReturnType> Function() request,
    required FailureType Function(String? message) onFailure,
  }) async {
    try {
      return Right(await request());
    } on AppException catch (e) {
      return Left(onFailure(e.message));
    } catch (e) {
      log(name: 'RepositoryHandlerMixin: ', e.toString());
      rethrow;
    }
  }
}
