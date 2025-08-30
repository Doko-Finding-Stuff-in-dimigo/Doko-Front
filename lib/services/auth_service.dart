import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '1089946968312-n0s6n875vfd8csai1l00s853tdr22719.apps.googleusercontent.com',
  );
  final Dio _dio = Dio();
  final String _baseUrl = 'https://doko.trillion-won.com';

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('User cancelled the sign-in flow');
        return null;
      }

      // Get auth token
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print('Failed to get ID token');
        return null;
      }

      print('Sending token to backend...');
      // Send token to backend
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {
          'token': idToken,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      print('Backend response status: ${response.statusCode}');
      print('Backend response data: ${response.data}');

      if (response.statusCode == 200) {
        // Save user data and tokens
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.data['token']);
        await prefs.setString('user_data', response.data.toString());

        return response.data;
      } else {
        print('Backend error: ${response.statusCode} - ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      print('Dio error type: ${e.type}');
      print('Dio error response: ${e.response}');
      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<bool> isSignedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('auth_token');
    } catch (e) {
      print('Error checking sign in status: $e');
      return false;
    }
  }
}
