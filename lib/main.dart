import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'router/app_router.dart';
import 'services/local_storage_service.dart';
import 'services/connectivity_service.dart';
import 'screens/no_connection_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local storage
  await LocalStorageService.init();

  await Supabase.initialize(
    url: 'https://aurxykjqywoaiezwkvff.supabase.co',
    anonKey: 'sb_publishable_VwBR1xse_Z2Zgs4b0kjYhA_w54eXJP8',
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A1A1A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  // Optimize image cache — limit memory to reduce RAM usage
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50 MB
  PaintingBinding.instance.imageCache.maximumSize = 30; // max 30 images cached

  runApp(const ProviderScope(child: KurgateApp()));
}

final supabase = Supabase.instance.client;

class KurgateApp extends ConsumerWidget {
  const KurgateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final connectivityAsync = ref.watch(connectivityProvider);

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
      builder: (context, child) {
        // Show "No Connection" overlay when offline
        return connectivityAsync.when(
          data: (isConnected) {
            if (!isConnected) {
              return const NoConnectionScreen();
            }
            return child ?? const SizedBox.shrink();
          },
          loading: () => child ?? const SizedBox.shrink(),
          error: (_, _) => child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
