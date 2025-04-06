import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pocketbase/pocketbase.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5765F2), // 앱 전체의 주요 색상
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 2초 후 로그인 화면으로 이동
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
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
        child: Center(
          child: Image.asset(
            'assets/images/Onboarding.png',
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

  void _onContinue() {
    String email = _emailController.text;
    print('입력된 이메일: $email');
    // 실제 앱에서는 여기서 인증 로직 실행
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
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
                          onPressed: () {
                            print('구글 로그인');
                          },
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
                                  return Colors.grey
                                      .withOpacity(0.1); // 눌렀을 때 효과 색상
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
    const Center(child: Text('탭 5')),
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
                },
              ),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // ✅ 겹치지 않게 띄움
    );
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

  String formatRelativeTime(String utcTimeString) {
    final utcTime = DateTime.parse(utcTimeString); // 2025-03-26T12:00:00.000Z
    final kstTime = utcTime.toLocal(); // 이미 시스템 KST 기준으로 변환됨
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
                  onPressed: () => {},
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
              ? ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 85,
                                height: 85,
                                color: Colors.grey.shade200,
                                child:
                                    const Icon(Icons.image, size: 40), // 이미지 자리
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('에어팟 찾아요',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('잃어버린 장소: 학봉관 - 10분 전',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13)),
                                  const SizedBox(height: 4),
                                  const Text('사례: 매점 1000원',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

                            return GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => DetailPage(post: post),
                                //   ),
                                // );
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

class DetailPage extends StatelessWidget {
  final RecordModel post;
  const DetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final image = post.getStringValue('field');
    final title = post.getStringValue('title');
    final where = post.getStringValue('where');
    final reward = post.getStringValue('reward');
    final lostTime = post.getStringValue('lost_time');

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              'https://snowman0919.site/api/files/doko_find_post/${post.id}/$image',
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text('장소: $where'),
            Text('사례: $reward'),
            Text('잃어버린 시간: $lostTime'),
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
    return const Scaffold();
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

class _NotificationPageState extends State<ExploreTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
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
