import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://aurxykjqywoaiezwkvff.supabase.co',
    anonKey: 'sb_publishable_VwBR1xse_Z2Zgs4b0kjYhA_w54eXJP8',
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: KurgateApp()));
}

final supabase = Supabase.instance.client;

class KurgateApp extends ConsumerWidget {
  const KurgateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Kurgate',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        fontFamily: 'DarkerGrotesque',
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'DarkerGrotesque',
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF8C00),
          secondary: Color(0xFFFCA91C),
          tertiary: Color(0xFFE77728),
          surface: Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
