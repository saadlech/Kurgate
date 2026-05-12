import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Profil', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
            const SizedBox(height: 32),

            // Avatar + Name
            Center(child: Column(children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFE77728)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [BoxShadow(color: const Color(0xFFFF8C00).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Center(child: Text(
                  _initials(user?.nom ?? 'U'),
                  style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.black, fontSize: 32, fontWeight: FontWeight.w800),
                )),
              ),
              const SizedBox(height: 14),
              Text(user?.nom ?? 'Utilisateur', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(user?.email ?? '', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
            ])),
            const SizedBox(height: 32),

            // Info tiles
            _infoTile(Icons.person_rounded, 'Nom complet', user?.nom ?? '-'),
            _infoTile(Icons.email_rounded, 'Email', user?.email ?? '-'),
            _infoTile(Icons.phone_rounded, 'Téléphone', user != null && user.numDeTelephone > 0 ? '+212 ${user.numDeTelephone}' : '-'),

            const SizedBox(height: 20),

            // Edit Profile button
            GestureDetector(
              onTap: () => context.push('/edit-profile'),
              child: Container(
                height: 52, width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF8C00).withValues(alpha: 0.12),
                      const Color(0xFFE77728).withValues(alpha: 0.06),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF8C00).withValues(alpha: 0.2)),
                ),
                child: const Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.edit_rounded, color: Color(0xFFFF8C00), size: 20),
                  SizedBox(width: 8),
                  Text('Modifier le profil', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 16, fontWeight: FontWeight.w700)),
                ])),
              ),
            ),

            const Spacer(),

            // Delete Account
            GestureDetector(
              onTap: () => _showDeleteAccountDialog(context, ref),
              child: Container(
                height: 52, width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.delete_forever_rounded, color: Colors.white.withValues(alpha: 0.4), size: 20),
                  const SizedBox(width: 8),
                  Text('Supprimer le compte', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 16, fontWeight: FontWeight.w700)),
                ])),
              ),
            ),
            const SizedBox(height: 10),

            // Logout
            GestureDetector(
              onTap: () => _showLogoutDialog(context, ref),
              child: Container(
                height: 52, width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5252).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF5252).withValues(alpha: 0.2)),
                ),
                child: const Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.logout_rounded, color: Color(0xFFFF5252), size: 20),
                  SizedBox(width: 8),
                  Text('Se déconnecter', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF5252), fontSize: 16, fontWeight: FontWeight.w700)),
                ])),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  Widget _infoTile(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withValues(alpha: 0.06))),
      child: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xFFFF8C00).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xFFFF8C00), size: 18)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.35), fontSize: 11, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        ])),
      ]),
    ),
  );

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF222222),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Se déconnecter ?', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontWeight: FontWeight.w800)),
      content: Text('Vous serez redirigé vers la page de connexion.', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Annuler', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w700))),
        TextButton(onPressed: () {
          Navigator.pop(ctx);
          ref.read(authProvider.notifier).logout();
          context.go('/login');
        }, child: const Text('Déconnexion', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF5252), fontWeight: FontWeight.w700))),
      ],
    ));
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    final confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final isConfirmed = confirmController.text.trim() == 'SUPPRIMER';
          return AlertDialog(
            backgroundColor: const Color(0xFF222222),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFFF5252), size: 24),
              SizedBox(width: 10),
              Text('Supprimer le compte', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            ]),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cette action est irréversible. Toutes vos données, réservations et informations personnelles seront définitivement supprimées.',
                  style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6), fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 18),
                Text(
                  'Tapez SUPPRIMER pour confirmer :',
                  style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'SUPPRIMER',
                    hintStyle: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.15)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Annuler', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w700)),
              ),
              TextButton(
                onPressed: isConfirmed ? () async {
                  Navigator.pop(ctx);
                  final success = await ref.read(authProvider.notifier).deleteAccount();
                  if (success && context.mounted) {
                    context.go('/login');
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        ref.read(authProvider).errorMessage ?? 'Échec de la suppression du compte.',
                        style: const TextStyle(fontFamily: 'DarkerGrotesque'),
                      ),
                      backgroundColor: const Color(0xFFFF5252),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ));
                  }
                } : null,
                child: Text(
                  'Supprimer',
                  style: TextStyle(
                    fontFamily: 'DarkerGrotesque',
                    color: isConfirmed ? const Color(0xFFFF5252) : const Color(0xFFFF5252).withValues(alpha: 0.3),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
