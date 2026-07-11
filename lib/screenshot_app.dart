import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/screenshot/screenshot_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF1A1A1A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const ScreenshotApp());
}

const kOrange = Color(0xFFFF8C00);
const kDarkBg = Color(0xFF1A1A1A);
const kDarker = Color(0xFF0F0F0F);
const kFont = 'DarkerGrotesque';

class ScreenshotApp extends StatelessWidget {
  const ScreenshotApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Kurgate',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kDarkBg,
      fontFamily: kFont,
      colorScheme: const ColorScheme.dark(
        primary: kOrange,
        secondary: Color(0xFFFCA91C),
        surface: kDarkBg,
      ),
    ),
    home: const ScreenshotShell(),
  );
}

class ScreenshotShell extends StatefulWidget {
  const ScreenshotShell({super.key});
  @override
  State<ScreenshotShell> createState() => _ScreenshotShellState();
}

class _ScreenshotShellState extends State<ScreenshotShell> {
  int _i = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeTab(onProfile: () => setState(() => _i = 3)),
      const ChatTab(),
      const ShopTab(),
      const ProfileTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const tabs = [
      (Icons.home_rounded, 'Accueil'),
      (Icons.smart_toy_rounded, 'Assistant'),
      (Icons.storefront_rounded, 'Artisanat'),
      (Icons.person_rounded, 'Profil'),
    ];
    return Scaffold(
      backgroundColor: kDarkBg,
      body: IndexedStack(index: _i, children: _screens),
      floatingActionButton: _i != 1 ? Padding(
        padding: const EdgeInsets.only(bottom: 56),
        child: GestureDetector(
          onTap: () => setState(() => _i = 1),
          child: SizedBox(width: 64, height: 72, child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(bottom: 2, child: Container(width: 40, height: 12,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: kOrange.withValues(alpha: 0.4), blurRadius: 18, spreadRadius: 4)]))),
              Image.asset('assets/images/ai_assistant.png', width: 64, height: 72, fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Container(width: 56, height: 56,
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [kOrange, Color(0xFFE77728)]), shape: BoxShape.circle),
                  child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 26))),
            ],
          )),
        ),
      ) : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: kDarkBg,
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06)))),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (i) {
              final active = i == _i;
              return GestureDetector(
                onTap: () => setState(() => _i = i),
                behavior: HitTestBehavior.opaque,
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(tabs[i].$1, color: active ? kOrange : Colors.white.withValues(alpha: 0.35), size: 24),
                    const SizedBox(height: 4),
                    Text(tabs[i].$2, style: TextStyle(fontFamily: kFont,
                      color: active ? kOrange : Colors.white.withValues(alpha: 0.3),
                      fontSize: 11, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
                  ])),
              );
            })),
        )),
      ),
    );
  }
}
