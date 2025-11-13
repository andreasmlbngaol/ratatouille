import 'package:dartz/dartz.dart';
import 'package:ratatouille/domain/model/failure.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';

class SignUpWithEmailUseCase {
  final AuthService authService;

  SignUpWithEmailUseCase(this.authService);

  Future<Either<Failure, String>> call({
    required String email,
    required String password,
    required String confirmPassword
  }) async {
    try {
      _validateEmail(email).fold(
          (failure) {
            return Left(failure);
          },
          (_) => null
      );

      _validatePassword(password, confirmPassword).fold(
          (failure) {
            return Left(failure);
          },
          (_) => null
      );

      final idToken = await authService.signUpWithEmailAndPassword(
          email: email,
          password: password
      );
      return Right(idToken);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Either<Failure, void> _validateEmail(String email) {
    if (email.isEmpty) {
      return Left(Failure("Email tidak boleh kosong"));
    }

    // Panjang maksimal 320 karakter
    if (email.length > 320) {
      return Left(Failure("Email terlalu panjang (maksimal 320 karakter)"));
    }

    // Harus ada satu '@'
    final parts = email.split('@');
    if (parts.length != 2) {
      return Left(Failure("Email harus memiliki satu '@'"));
    }

    final localPart = parts[0];
    final domainPart = parts[1];

    // Local part tidak boleh kosong
    if (localPart.isEmpty) {
      return Left(Failure("Bagian sebelum '@' tidak boleh kosong"));
    }

    // Domain tidak boleh kosong
    if (domainPart.isEmpty) {
      return Left(Failure("Bagian setelah '@' tidak boleh kosong"));
    }

    // Local part tidak boleh diawali atau diakhiri titik
    if (localPart.startsWith('.') || localPart.endsWith('.')) {
      return Left(Failure("Bagian lokal tidak boleh diawali atau diakhiri dengan titik"));
    }

    // Tidak boleh ada dua titik berurutan
    if (localPart.contains('..')) {
      return Left(Failure("Bagian lokal tidak boleh memiliki dua titik berurutan"));
    }

    // Local part hanya boleh berisi karakter tertentu
    final allowedLocal = RegExp(r'^[a-zA-Z0-9._%+\-]+$');
    if (!allowedLocal.hasMatch(localPart)) {
      return Left(Failure("Bagian lokal hanya boleh berisi huruf, angka, dan simbol ._%+-"));
    }

    // Domain harus mengandung minimal satu titik
    if (!domainPart.contains('.')) {
      return Left(Failure("Domain harus mengandung titik (misalnya gmail.com)"));
    }

    // Domain tidak boleh diawali atau diakhiri dengan titik atau tanda hubung
    if (domainPart.startsWith('.') || domainPart.endsWith('.')) {
      return Left(Failure("Domain tidak boleh diawali/diakhiri dengan titik atau tanda hubung"));
    }

    // Setiap segmen domain harus valid
    final domainSegments = domainPart.split('.');
    for (final seg in domainSegments) {
      if (seg.isEmpty) {
        return Left(Failure("Domain memiliki segmen kosong (misalnya dua titik berurutan)"));
      }
      if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(seg)) {
        return Left(Failure("Domain hanya boleh berisi huruf, angka, dan tanda hubung"));
      }
    }

    // TLD (ekstensi terakhir) minimal 2 huruf
    final tld = domainSegments.last;
    if (tld.length < 2 || !RegExp(r'^[a-zA-Z]+$').hasMatch(tld)) {
      return Left(Failure("Ekstensi domain tidak valid"));
    }

    return Right(null);
  }

  Either<Failure, void> _validatePassword(String password,
      String confirmPassword) {
    if (password.length < 6) {
      return Left(Failure("Password must be at least 6 characters"));
    }

    if (!password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]'))) {
      return Left(Failure(
          "Password must contain at least one uppercase and one lowercase letter"));
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return Left(Failure("Password must contain at least one number"));
    }

    if (password != confirmPassword) {
      return Left(Failure("Passwords do not match"));
    }

    return Right(null);
  }
}