import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:ratatouille/core/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';

class SignUpWithEmailUseCase {
  final AuthService authService;

  SignUpWithEmailUseCase(this.authService);

  Future<Either<Failure, String>> call({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      debugPrint('📝 SignUpWithEmailUseCase: Starting validation');

      // ✅ VALIDATE EMAIL - return early jika ada error
      final emailValidation = _validateEmail(email);
      final emailResult = emailValidation.fold(
            (failure) {
          debugPrint('❌ Email validation failed: ${failure.message}');
          return Left<Failure, void>(failure);
        },
            (_) {
          debugPrint('✅ Email validation passed');
          return Right<Failure, void>(null);
        },
      );

      if (emailResult.isLeft()) {
        return emailResult.fold(
              (failure) => Left(failure),
              (_) => Right(''), // This won't execute
        );
      }

      // ✅ VALIDATE PASSWORD - return early jika ada error
      final passwordValidation = _validatePassword(password, confirmPassword);
      final passwordResult = passwordValidation.fold(
            (failure) {
          debugPrint('❌ Password validation failed: ${failure.message}');
          return Left<Failure, void>(failure);
        },
            (_) {
          debugPrint('✅ Password validation passed');
          return Right<Failure, void>(null);
        },
      );

      if (passwordResult.isLeft()) {
        return passwordResult.fold(
              (failure) => Left(failure),
              (_) => Right(''), // This won't execute
        );
      }

      // ✅ All validation passed, proceed to Firebase sign up
      debugPrint('✅ All validations passed, calling Firebase sign up');

      final idToken = await authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(idToken);
    } catch (e) {
      debugPrint('⚠️ Exception during SignUpWithEmailUseCase: $e');
      return Left(Failure(e.toString()));
    }
  }

  Either<Failure, void> _validateEmail(String email) {
    debugPrint('🔍 Validating email: $email');

    if (email.isEmpty) {
      return Left(Failure("Email tidak boleh kosong"));
    }

    if (email.length > 320) {
      return Left(Failure("Email terlalu panjang (maksimal 320 karakter)"));
    }

    final parts = email.split('@');
    if (parts.length != 2) {
      return Left(Failure("Email harus memiliki satu '@'"));
    }

    final localPart = parts[0];
    final domainPart = parts[1];

    if (localPart.isEmpty) {
      return Left(Failure("Bagian sebelum '@' tidak boleh kosong"));
    }

    if (domainPart.isEmpty) {
      return Left(Failure("Bagian setelah '@' tidak boleh kosong"));
    }

    if (localPart.startsWith('.') || localPart.endsWith('.')) {
      return Left(Failure("Bagian lokal tidak boleh diawali atau diakhiri dengan titik"));
    }

    if (localPart.contains('..')) {
      return Left(Failure("Bagian lokal tidak boleh memiliki dua titik berurutan"));
    }

    final allowedLocal = RegExp(r'^[a-zA-Z0-9._%+\-]+$');
    if (!allowedLocal.hasMatch(localPart)) {
      return Left(Failure("Bagian lokal hanya boleh berisi huruf, angka, dan simbol ._%+-"));
    }

    if (!domainPart.contains('.')) {
      return Left(Failure("Domain harus mengandung titik (misalnya gmail.com)"));
    }

    if (domainPart.startsWith('.') || domainPart.endsWith('.')) {
      return Left(Failure("Domain tidak boleh diawali/diakhiri dengan titik atau tanda hubung"));
    }

    final domainSegments = domainPart.split('.');
    for (final seg in domainSegments) {
      if (seg.isEmpty) {
        return Left(Failure("Domain memiliki segmen kosong (misalnya dua titik berurutan)"));
      }
      if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(seg)) {
        return Left(Failure("Domain hanya boleh berisi huruf, angka, dan tanda hubung"));
      }
    }

    final tld = domainSegments.last;
    if (tld.length < 2 || !RegExp(r'^[a-zA-Z]+$').hasMatch(tld)) {
      return Left(Failure("Ekstensi domain tidak valid"));
    }

    debugPrint('✅ Email validation passed');
    return Right(null);
  }

  Either<Failure, void> _validatePassword(String password, String confirmPassword) {
    debugPrint('🔍 Validating password: length=${password.length}');
    if (password != confirmPassword) {
      debugPrint('❌ Confirm password tidak cocok');
      return Left(Failure("Password dan konfirmasi password tidak cocok"));
    }

    if (password.length < 6) {
      debugPrint('❌ Password harus minimal 6 karakter');
      return Left(Failure("Password harus minimal 6 karakter"));
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      debugPrint('❌ Password harus mengandung minimal satu huruf besar (A-Z)');
      return Left(Failure("Password harus mengandung minimal satu huruf besar (A-Z)"));
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      debugPrint('❌ Password harus mengandung minimal satu huruf kecil (a-z)');
      return Left(Failure("Password harus mengandung minimal satu huruf kecil (a-z)"));
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      debugPrint('❌ Password harus mengandung minimal satu angka (0-9)');
      return Left(Failure("Password harus mengandung minimal satu angka (0-9)"));
    }
    return Right(null);
  }
}