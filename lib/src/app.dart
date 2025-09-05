import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pocketbase/pocketbase.dart';
import '../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'settings/settings_controller.dart';

// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doko Find',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5765F2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5765F2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Check if user is already signed in
      final isSignedIn = await _authService.isSignedIn();

      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                isSignedIn ? const HomeScreen() : const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      print('Error initializing app: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF84C5F4), Color(0xFF1479FF)],
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF75BDF6), Color(0xFF1565EF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 가운데 돋보기 이미지
                Image.asset(
                  'assets/images/Docoicon.png',
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 40),
                const Text(
                  '도코',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '디미고의 잃어버린 물건들을 위하여',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  void _onContinue() {
    String email = _emailController.text;
    print('입력된 이메일: $email');
    // 실제 앱에서는 여기서 인증 로직 실행
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      // Ensure presentingViewController is set (for iOS)
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // Use a method channel or native code to ensure rootViewController is assigned (this may need to be handled natively in AppDelegate.swift)
        debugPrint('Ensure presentingViewController is properly set on iOS');
      }

      final result = await _authService.signInWithGoogle();
      if (result != null) {
        // 로그인 성공
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // 로그인 실패
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google 로그인에 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Google sign in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인 중 오류가 발생했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 앱 이름 및 설명
                      const SizedBox(height: 48),
                      const Text(
                        'Doko?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '디미고의 잃어버린 물건들을 위하여',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 32),

                      // 계정 만들기
                      const Text(
                        '계정 만들기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your email to sign up for this app',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                      // 이메일 입력창
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'email@dimigo.hs.kr',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF5765F2)), // 포커스 상태
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Continue 버튼
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5765F2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 구분선
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('or'),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Google 로그인 버튼 (아이콘 비워둠)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: _handleGoogleSignIn,
                          icon: const Icon(
                            Icons.g_mobiledata,
                            color: Colors.black,
                          ),
                          label: const Text(
                            '디미고 Google 계정으로 시작하기',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            side: WidgetStateProperty.all(
                              const BorderSide(color: Colors.grey),
                            ),
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.grey.withOpacity(0.1);
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // SSO 버튼 (아이콘 비워둠)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            print('SSO로 로그인');
                          },
                          icon: const Icon(
                            Icons.apartment,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'SSO로 로그인',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            side: WidgetStateProperty.all(
                              const BorderSide(color: Colors.grey),
                            ),
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.grey
                                      .withOpacity(0.1); // 눌렀을 때 효과 색상
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 약관 안내
                      const Text.rich(
                        TextSpan(
                          text: 'By clicking continue, you agree to our ',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // 하단 크레딧 (예시)
                      const Text(
                        '1628 최윤혁(총책임자 및 프론트, 백 일부), 1630 한예성(디자인 및 홍보),\n'
                        '1626 조원(백엔드), 1502 고준형(보안 이하 씹덕)',
                        style: TextStyle(fontSize: 10, color: Colors.black38),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLostSelected = true;

  final List<Widget> _pages = [
    const HomeTab(),
    const ExploreTab(),
    const SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Color(0xFF5765F2)),
            SizedBox(height: 20),
            Text(
              '현재 개발 중이에요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              '곧 만나볼 수 있어요!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
    const SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Color(0xFF5765F2)),
            SizedBox(height: 20),
            Text(
              '현재 개발 중이에요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              '곧 만나볼 수 있어요!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
    const SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Color(0xFF5765F2)),
            SizedBox(height: 20),
            Text(
              '현재 개발 중이에요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              '곧 만나볼 수 있어요!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF5765F2),
        unselectedItemColor: const Color(0x705765F2),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.explore : Icons.explore_outlined,
              size: 30,
            ),
            label: 'View',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2
                  ? Icons.local_offer
                  : Icons.local_offer_outlined,
              size: 30,
            ),
            label: 'Tag',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.chat_bubble
                  : Icons.chat_bubble_outline,
              size: 30,
            ),
            label: 'Chating',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 4 ? Icons.person : Icons.person_outline,
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          // ? FloatingActionButton(
          //     onPressed: () {
          //       // 추가 동작
          //     },
          //     backgroundColor: Colors.blue,
          //     child: const Icon(Icons.add, size: 30),
          //   )
          // : null
          ? Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF96A6FF), Color(0xFF4361EE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 40),
                onPressed: () {
                  // 버튼 눌렀을 때 동작
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Writing(),
                    ),
                  );
                },
              ),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // ✅ 겹치지 않게 띄움
    );
  }
}

String formatRelativeTime(String utcTimeString) {
  final utcTime = DateTime.parse(utcTimeString);
  final kstTime = utcTime.toLocal();
  final now = DateTime.now();
  final diff = now.difference(kstTime);

  if (diff.inSeconds < 60) {
    return '방금 전';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes}분 전';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}시간 전';
  } else if (diff.inDays < 30) {
    return '${diff.inDays}일 전';
  } else if (diff.inDays < 365) {
    return '${(diff.inDays / 30).floor()}달 전';
  } else {
    return '${(diff.inDays / 365).floor()}년 전';
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isLostSelected = true;

  Future<List<RecordModel>> fetchPosts() async {
    final pb = PocketBase('https://snowman0919.site');

    final result = await pb.collection('doko_find_post').getFullList();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 검색창 + 알림
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 12, 12),
          child: Row(
            children: [
              Expanded(
                  child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: const TextSelectionThemeData(
                    selectionColor: Colors.black26, // 선택된 배경 색상
                    cursorColor: Colors.black, // 커서 색
                    selectionHandleColor: Colors.black, // 핸들(동그라미) 색
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    focusColor: Colors.black,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              )),
              const SizedBox(width: 12),
              IconButton(
                  onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationPage(),
                          ),
                        )
                      },
                  icon: const Icon(Icons.notifications_none, size: 28))
            ],
          ),
        ),

        // 탭 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isLostSelected = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isLostSelected
                          ? const Color(0xFF5D6BFF)
                          : const Color(0xFFE7E7FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '물건 찾아요',
                        style: TextStyle(
                          color: isLostSelected
                              ? Colors.white
                              : const Color(0xFF5D6BFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isLostSelected = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !isLostSelected
                          ? const Color(0xFF5D6BFF)
                          : const Color(0xFFE7E7FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '주인 찾아요',
                        style: TextStyle(
                          color: !isLostSelected
                              ? Colors.white
                              : const Color(0xFF5D6BFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // 리스트
        Expanded(
          child: isLostSelected == true
              ? FutureBuilder<List<RecordModel>>(
                  future: fetchPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('게시물이 없습니다.'));
                    }
                    final posts = snapshot.data!;
                    return RefreshIndicator(
                        color: const Color(0xFF5D6BFF),
                        backgroundColor: const Color(0xFFE7E7FF),
                        onRefresh: () async {
                          setState(
                              () {}); // fetchPosts()가 FutureBuilder에서 다시 호출되도록 함
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final title = post.getStringValue('title');
                            final where = post.getStringValue('where');
                            final reward = post.getStringValue('reward');
                            final lostTime = post.getStringValue('lost_time');
                            final encordedlostTime =
                                formatRelativeTime(lostTime.toString());
                            final image =
                                post.getStringValue('field').toString();
                            final encodedImage =
                                image.substring(1, image.length - 1);

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(post: post),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(16),
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300))),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            'https://snowman0919.site/api/files/whc6wpbuzpiw3fw/${post.id}/$encodedImage',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(title,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(height: 4),
                                              Text(
                                                  '잃어버린 장소: $where - $encordedlostTime',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 13)),
                                              const SizedBox(height: 4),
                                              Text('사례: $reward',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ));
                  },
                )
              : FutureBuilder<List<RecordModel>>(
                  future: fetchPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('게시물이 없습니다.'));
                    }
                    final posts = snapshot.data!;
                    return RefreshIndicator(
                        color: const Color(0xFF5D6BFF),
                        backgroundColor: const Color(0xFFE7E7FF),
                        onRefresh: () async {
                          setState(
                              () {}); // fetchPosts()가 FutureBuilder에서 다시 호출되도록 함
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final title = post.getStringValue('title');
                            final where = post.getStringValue('where');
                            final reward = post.getStringValue('reward');
                            final lostTime = post.getStringValue('lost_time');
                            final encordedlostTime =
                                formatRelativeTime(lostTime.toString());
                            final image =
                                post.getStringValue('field').toString();
                            final encodedImage =
                                image.substring(1, image.length - 1);

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(post: post),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(16),
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300))),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            'https://snowman0919.site/api/files/whc6wpbuzpiw3fw/${post.id}/$encodedImage',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(title,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(height: 4),
                                              Text(
                                                  '잃어버린 장소: $where - $encordedlostTime',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 13)),
                                              const SizedBox(height: 4),
                                              Text('사례: $reward',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ));
                  },
                ),
        )
      ],
    );
  }
}

class Writing extends StatefulWidget {
  const Writing({super.key});

  @override
  State<Writing> createState() => _WritingState();
}

class _WritingState extends State<Writing> {
  bool isLostSelected = true;

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  // 이미지를 가져오는 함수
  Future<void> getImage(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: imageSource);
      if (pickedFile != null) {
        if (!mounted) return;
        setState(() {
          _image = XFile(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Image pick failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 불러오지 못했어요. 다시 시도해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('새 게시글 작성'),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  '임시 저장하기',
                  style: TextStyle(color: Color(0xFF5765F2)),
                ),
              )
            ],
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 이미지 업로드 박스
                  Ink(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF83828b)),
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () async => await getImage(ImageSource.gallery),
                        borderRadius: BorderRadius.circular(10),
                        child: const Center(
                          child: Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey),
                        ),
                      )),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isLostSelected = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isLostSelected
                                    ? const Color(0xFF5D6BFF)
                                    : const Color(0xFFE7E7FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  '물건 찾아요',
                                  style: TextStyle(
                                    color: isLostSelected
                                        ? Colors.white
                                        : const Color(0xFF5D6BFF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isLostSelected = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isLostSelected
                                    ? const Color(0xFF5D6BFF)
                                    : const Color(0xFFE7E7FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  '주인 찾아요',
                                  style: TextStyle(
                                    color: !isLostSelected
                                        ? Colors.white
                                        : const Color(0xFF5D6BFF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    decoration: InputDecoration(
                      hintText: !isLostSelected
                          ? '주인을 찾고 싶은 물건이 뭔가요?'
                          : '찾고 싶은 물건이 뭔가요?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF5765F2)), // 포커스 상태
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "사례",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  // 가격 입력
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: '₩ ',
                      hintText: '(선택 ex.매점, 감사)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF5765F2)), // 포커스 상태
                      ),
                    ),
                  ),
                  // const SizedBox(height: 8),

                  // // 제안 허용 여부
                  // Row(
                  //   children: [
                  //     Checkbox(value: false, onChanged: (value) {}),
                  //     const Text('Open to offers'),
                  //   ],
                  // ),
                  const SizedBox(height: 16),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "설명",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: !isLostSelected
                          ? '주인을 찾고 싶은 물건의 간단한 설명을 입력해주세요!'
                          : '찾고 싶은 물건의 특징, 브렌드, 제조사, 소재, 크기 등의 설명을 입력해주세요!',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF5765F2)), // 포커스 상태
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    title: const Text('만날 장소'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(),

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          '선생님을 통해 전달하기',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Switch(value: false, onChanged: (value) {}),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 70,
            color: const Color(0xFF5765F2),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Center(
                child: Text(
                  '게시하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ));
  }
}

class DetailPage extends StatefulWidget {
  final RecordModel post;
  const DetailPage({super.key, required this.post});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool notifyTags = false;
  bool bookmarked = false;
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final image = post.getStringValue('field');
    final title = post.getStringValue('title');
    final where = post.getStringValue('where');
    final reward = post.getStringValue('reward');
    final lostTime = post.getStringValue('lost_time');
    final encodedLostTime = formatRelativeTime(lostTime.toString());
    // Try common description fields; fall back to placeholder text
    String description = post.getStringValue('description');
    if (description.isEmpty) {
      description = post.getStringValue('desc');
    }
    if (description.isEmpty) {
      description = post.getStringValue('content');
    }
    if (description.isEmpty) {
      description = '에어팟 잃어버렸어요. 프로 2세대이고 실리콘 케이스가 있어요.';
    }
    final encodedImage =
        Uri.encodeComponent(image.replaceAll('[', '').replaceAll(']', ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => bookmarked = !bookmarked),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    bookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('사례: $reward',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D6BFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('찾았어요!(연락)'),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://snowman0919.site/api/files/doko_find_post/${post.id}/$encodedImage',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/snowman.png'),
                radius: 24,
              ),
              title: const Text('1628 최윤혁',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        width: 70,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        width: 55,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(90, 97, 174, 1),
                              Color.fromRGBO(104, 117, 255, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const Positioned(
                        right: 8,
                        child: Text('97', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Finder 지수란?',
                      style: TextStyle(fontSize: 10, color: Colors.grey))
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('잃어버린 장소: $where - $encodedLostTime',
                      style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                          label: Text('#악세서리', style: TextStyle(fontSize: 12))),
                      Chip(label: Text('#에어팟', style: TextStyle(fontSize: 12))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Hashtag notification row
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('#악세서리 #에어팟 테그 알림 받기'),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => notifyTags = !notifyTags),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text('알람설정'),
                          const SizedBox(width: 8),
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Icon(
                                notifyTags
                                    ? Icons.notifications_active
                                    : Icons.notifications_none,
                              ),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade400, width: 1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '1',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80, color: Color(0xFF5765F2)),
              SizedBox(height: 20),
              Text(
                '현재 개발 중이에요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                '곧 만나볼 수 있어요!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TagCtrlTab extends StatefulWidget {
  const TagCtrlTab({super.key});

  @override
  _TagCtrlTabState createState() => _TagCtrlTabState();
}

class _TagCtrlTabState extends State<ExploreTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80, color: Colors.orange),
              SizedBox(height: 20),
              Text(
                '현재 개발 중이에요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                '곧 만나볼 수 있어요!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FootTrakTab extends StatefulWidget {
  const FootTrakTab({super.key});

  @override
  _FootTrakTabState createState() => _FootTrakTabState();
}

class _FootTrakTabState extends State<FootTrakTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80, color: Colors.orange),
              SizedBox(height: 20),
              Text(
                '현재 개발 중이에요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                '곧 만나볼 수 있어요!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80, color: Color(0xFF5765F2)),
              SizedBox(height: 20),
              Text(
                '현재 개발 중이에요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                '곧 만나볼 수 있어요!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MypageTab extends StatefulWidget {
  const MypageTab({super.key});

  @override
  _MypageTabState createState() => _MypageTabState();
}

class _MypageTabState extends State<ExploreTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
