import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    hostedDomain: 'dimigo.hs.kr', // 디미고 계정만 허용 (선택)
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        // 사용자가 취소한 경우
        return null;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      print('✅ 로그인 성공: ${account.email}');
      print('✅ idToken: $idToken');

      // TODO: 서버로 idToken 전송하고 검증하면 여기서 처리 가능
      return account;
    } catch (e) {
      print('❌ Google 로그인 실패: $e');
      return null;
    }
  }

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}