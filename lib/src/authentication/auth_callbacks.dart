import 'dart:async';
import 'package:rafi_login_template/src/models/login_credentials.dart';

/// Function signature for the login callback.
///
/// Can return an [AuthResult], complete normally on success, or throw an exception
/// with a user-friendly error message on failure.
typedef RafiLoginCallback =
    FutureOr<dynamic> Function(LoginCredentials credentials);

/// Function signature for post-authentication callback.
typedef RafiAuthenticatedCallback = void Function(LoginCredentials credentials);
