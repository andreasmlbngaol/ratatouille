import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ratatouille/core/di/service_locator.dart';
import 'package:ratatouille/core/data/constant/app_constant.dart';
import 'package:ratatouille/core/data/network/dio_api_client.dart';
import 'package:ratatouille/core/data/network/firebase_token_provider.dart';
import 'package:ratatouille/core/domain/network/api_client.dart';
import 'package:ratatouille/core/domain/network/token_provider.dart';
import 'package:ratatouille/features/users/data/data_sources/auth_local_data_source_impl.dart';
import 'package:ratatouille/features/users/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:ratatouille/features/users/data/repository/users_repository_impl.dart';
import 'package:ratatouille/features/users/data/service/firebase_auth_service.dart';
import 'package:ratatouille/features/users/domain/data_source/auth_local_data_source.dart';
import 'package:ratatouille/features/users/domain/data_source/auth_remote_data_source.dart';
import 'package:ratatouille/features/users/domain/repository/users_repository.dart';
import 'package:ratatouille/features/users/domain/service/auth_service.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/authenticate_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/check_auth_status_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/sign_out_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/sign_in_with_email_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/sign_in_with_google_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/sign_up_with_email_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/auth/verify_email_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/profile/complete_profile_setup_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/profile/update_user_profile_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/social/manage_user_follow_use_case.dart';
import 'package:ratatouille/features/users/domain/use_case/social/view_user_profile_use_case.dart';

void setupUsersModule() {
  // Auth and Firebase
  getIt.registerSingleton<FirebaseAuth>(
    FirebaseAuth.instance,
  );

  getIt.registerSingleton<GoogleSignIn>(
      GoogleSignIn()
  );

  // Network
  getIt.registerSingleton<Dio>(
      Dio(
          BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30)
          )
      )
  );

  getIt.registerSingleton<AuthService>(
      FirebaseAuthService(
          firebaseAuth: getIt<FirebaseAuth>(),
          googleSignIn: getIt<GoogleSignIn>()
      )
  );

  getIt.registerSingleton<TokenProvider>(
      FirebaseTokenProvider(getIt<AuthService>())
  );

  getIt.registerSingleton<ApiClient>(
      DioApiClient(
          dio: getIt<Dio>(),
          baseUrl: AppConstant.baseUrl,
          tokenProvider: getIt<TokenProvider>()
      )
  );

  // Data Source
  getIt.registerSingleton<AuthLocalDataSource>(
      AuthLocalDataSourceImpl()
  );

  getIt.registerSingleton<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(apiClient: getIt<ApiClient>())
  );

  // Repository
  getIt.registerSingleton<UsersRepository>(
      UsersRepositoryImpl(
          remoteDataSource: getIt<AuthRemoteDataSource>(),
          localDataSource: getIt<AuthLocalDataSource>()
      )
  );

  // Use Case
  getIt.registerSingleton<AuthenticateUseCase>(
      AuthenticateUseCase(getIt<UsersRepository>())
  );

  getIt.registerSingleton<CheckAuthStatusUseCase>(
      CheckAuthStatusUseCase(getIt<UsersRepository>())
  );

  getIt.registerSingleton<SignOutUseCase>(
      SignOutUseCase(
          repository: getIt<UsersRepository>(),
          authService: getIt<AuthService>()
      )
  );

  getIt.registerSingleton<SignInWithEmailUseCase>(
      SignInWithEmailUseCase(getIt<AuthService>())
  );

  getIt.registerSingleton<SignInWithGoogleUseCase>(
      SignInWithGoogleUseCase(getIt<AuthService>())
  );

  getIt.registerSingleton<SignUpWithEmailUseCase>(
      SignUpWithEmailUseCase(getIt<AuthService>())
  );

  getIt.registerSingleton<VerifyEmailUseCase>(
      VerifyEmailUseCase(authService: getIt<AuthService>(), repository: getIt<UsersRepository>())
  );

  getIt.registerSingleton<CompleteProfileSetupUseCase>(
      CompleteProfileSetupUseCase(getIt<UsersRepository>())
  );

  getIt.registerSingleton<UpdateUserProfileUseCase>(
      UpdateUserProfileUseCase(getIt<UsersRepository>())
  );

  getIt.registerSingleton<ManageUserFollowUseCase>(
      ManageUserFollowUseCase(getIt<UsersRepository>())
  );

  getIt.registerSingleton<ViewUserProfileUseCase>(
      ViewUserProfileUseCase(getIt<UsersRepository>())
  );

}