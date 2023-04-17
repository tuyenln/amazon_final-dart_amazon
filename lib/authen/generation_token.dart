import 'package:dart_amazon/helper/config.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dotenv/dotenv.dart';

String generateSecretKey(String input) {
  var bytes = utf8.encode(input); // convert to bytes
  var digest = sha256.convert(bytes); // hash SHA256
  return digest.toString(); // return secret key
}

String createJwtToken(String username, String secretKey) {
  var jwt = JWT(
    {
      'username': '$username', // user
    },
    issuer: 'amazon.com', // app info
    audience: Audience(['amazon.com']), // infomation object use token
  );
  return jwt.sign(SecretKey('$secretKey')); // return JWT token
}

bool verifyJwtToken(String token, String secretKey) {
  try {
    var jwt = JWT.verify(token, SecretKey('$secretKey'));
    return true; // authen success
  } on JWTExpiredError {
    return false; // token expire
  } on JWTError catch (ex) {
    return false; // Error authen
  }
}

Future<bool> authentication(String user) async {
  var env = DotEnv(includePlatformEnvironment: true)..load();
  env.isEveryDefined(['EMAIL', 'JWT_SERRET']);
  String input = Properties.jwtSecret;
  String secretKey = generateSecretKey(input);

  String jwtToken = createJwtToken(user, secretKey);
  // print(jwtToken);

  bool isAuthenticated = verifyJwtToken(jwtToken, secretKey);
  return isAuthenticated;
}
