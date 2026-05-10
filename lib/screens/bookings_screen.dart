import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/booking_provider.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});
  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> with TickerProviderStateMixin {
  int _selectedFilter = 0;
  final _filters = const ['Tous', 'Hôtels', 'Véhicules', 'Expériences', 'Restaurants'];
  final _filterTypes = const [null, BookingType.hotel, BookingType.vehicule, BookingType.experience, BookingType.restaurant];

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(bookingProvider);
    final filtered = _selectedFilter == 0 ? bookings : bookings.where((b) => b.type == _filterTypes[_selectedFilter]).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 0), child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Mes Réservations', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
              Text('${bookings.length} réservation${bookings.length != 1 ? 's' : ''}', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 14)),
            ]),
            const Spacer(),
            if (bookings.isNotEmpty) GestureDetector(
              onTap: () => _showClearDialog(context),
              child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
                child: Icon(Icons.delete_sweep_rounded, color: Colors.white.withValues(alpha: 0.4), size: 22)),
            ),
          ])),
          const SizedBox(height: 16),
          // Filters
          if (bookings.isNotEmpty) SizedBox(height: 36, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: _filters.length, itemBuilder: (context, i) {
            final active = i == _selectedFilter;
            return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(onTap: () => setState(() => _selectedFilter = i),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: active ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(20), border: Border.all(color: active ? const Color(0xFFFF8C00) : Colors.white.withValues(alpha: 0.1))),
                child: Text(_filters[i], style: TextStyle(fontFamily: 'DarkerGrotesque', color: active ? Colors.black : Colors.white.withValues(alpha: 0.6), fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.w500)))));
          })),
          const SizedBox(height: 16),
          // Content
          Expanded(child: bookings.isEmpty ? _buildEmptyState() : filtered.isEmpty ? _buildNoFilterResults() : _buildBookingList(filtered)),
        ]),
      ),
    );
  }

  Widget _buildEmptyState() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), shape: BoxShape.circle),
      child: Icon(Icons.calendar_today_rounded, color: Colors.white.withValues(alpha: 0.15), size: 44)),
    const SizedBox(height: 20),
    Text('Aucune réservation', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 20, fontWeight: FontWeight.w700)),
    const SizedBox(height: 8),
    Text('Vos réservations apparaîtront ici\naprès confirmation', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.2), fontSize: 14, height: 1.5)),
  ]));

  Widget _buildNoFilterResults() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(Icons.filter_list_off_rounded, color: Colors.white.withValues(alpha: 0.15), size: 44),
    const SizedBox(height: 16),
    Text('Aucun résultat pour ce filtre', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.3), fontSize: 16, fontWeight: FontWeight.w600)),
  ]));

  Widget _buildBookingList(List<Booking> bookings) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    itemCount: bookings.length,
    separatorBuilder: (_, __) => const SizedBox(height: 16),
    itemBuilder: (context, index) {
      final booking = bookings[index];
      return _BookingCard(booking: booking, onDismissed: () {
        ref.read(bookingProvider.notifier).removeBooking(booking.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${booking.name} supprimé', style: const TextStyle(fontFamily: 'DarkerGrotesque')),
          backgroundColor: const Color(0xFF2A2A2A),
          action: SnackBarAction(label: 'Annuler', textColor: const Color(0xFFFF8C00), onPressed: () => ref.read(bookingProvider.notifier).addBooking(booking)),
        ));
      });
    },
  );

  void _showClearDialog(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF222222),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Tout supprimer ?', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontWeight: FontWeight.w800)),
      content: Text('Toutes vos réservations seront supprimées.', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.6))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Annuler', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w700))),
        TextButton(onPressed: () { ref.read(bookingProvider.notifier).clearAll(); Navigator.pop(ctx); }, child: const Text('Supprimer', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF5252), fontWeight: FontWeight.w700))),
      ],
    ));
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onDismissed;
  const _BookingCard({required this.booking, required this.onDismissed});

  IconData get _icon {
    switch (booking.type) {
      case BookingType.hotel: return Icons.hotel_rounded;
      case BookingType.vehicule: return Icons.directions_car_rounded;
      case BookingType.experience: return Icons.explore_rounded;
      case BookingType.restaurant: return Icons.restaurant_rounded;
    }
  }

  Color get _typeColor {
    switch (booking.type) {
      case BookingType.hotel: return const Color(0xFF4A90D9);
      case BookingType.vehicule: return const Color(0xFF2ECC71);
      case BookingType.experience: return const Color(0xFFE74C3C);
      case BookingType.restaurant: return const Color(0xFFF39C12);
    }
  }

  String _fmtDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(booking.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: const Color(0xFFFF5252).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.delete_rounded, color: Color(0xFFFF5252), size: 28),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(children: [
          // Image + type badge
          Stack(children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: AspectRatio(aspectRatio: 16 / 8, child: Image.asset(booking.imageUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF2A2A2A), child: Center(child: Icon(_icon, size: 40, color: Colors.white.withValues(alpha: 0.15))))))),
            // Type badge
            Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: _typeColor.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(_icon, color: Colors.white, size: 14), const SizedBox(width: 5),
                Text(booking.typeLabel, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ]))),
            // Price badge
            Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)),
              child: Text('\$${booking.totalPrice}', style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Color(0xFFFF8C00), fontSize: 14, fontWeight: FontWeight.w800)))),
            // Confirmed badge
            Positioned(bottom: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFF2ECC71).withValues(alpha: 0.9), borderRadius: BorderRadius.circular(10)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 14), SizedBox(width: 4),
                Text('Confirmé', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ]))),
          ]),
          // Details
          Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(booking.name, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
            const SizedBox(height: 4),
            Text(booking.subtitle, style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.4), fontSize: 13)),
            const SizedBox(height: 12),
            // Detail chips
            Wrap(spacing: 8, runSpacing: 8, children: booking.details.entries.map((e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withValues(alpha: 0.08))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('${e.key}: ', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.35), fontSize: 11, fontWeight: FontWeight.w500)),
                Text(e.value, style: const TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
            )).toList()),
            const SizedBox(height: 10),
            // Date
            Row(children: [
              Icon(Icons.access_time_rounded, color: Colors.white.withValues(alpha: 0.25), size: 14), const SizedBox(width: 4),
              Text('Réservé le ${_fmtDate(booking.createdAt)}', style: TextStyle(fontFamily: 'DarkerGrotesque', color: Colors.white.withValues(alpha: 0.25), fontSize: 11)),
            ]),
          ])),
        ]),
      ),
    );
  }
}
