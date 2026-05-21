import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';

/// A single search result from pgvector semantic search
class SearchResult {
  final String id;
  final String itemType; // 'hotel', 'restaurant', 'experience', 'boutique', 'vehicule'
  final String destinationId;
  final String name;
  final String content;
  final double similarity;

  const SearchResult({
    required this.id,
    required this.itemType,
    required this.destinationId,
    required this.name,
    required this.content,
    required this.similarity,
  });

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      id: map['id'] as String? ?? '',
      itemType: map['item_type'] as String? ?? '',
      destinationId: map['destination_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      content: map['content'] as String? ?? '',
      similarity: (map['similarity'] as num?)?.toDouble() ?? 0,
    );
  }

  /// User-friendly label for the item type
  String get typeLabel {
    switch (itemType) {
      case 'hotel':
        return 'Hôtel';
      case 'restaurant':
        return 'Restaurant';
      case 'experience':
        return 'Expérience';
      case 'boutique':
        return 'Boutique';
      case 'vehicule':
        return 'Véhicule';
      default:
        return itemType;
    }
  }

  /// Route path for navigation
  String get routePath {
    switch (itemType) {
      case 'hotel':
        return '/hotel/$id';
      case 'restaurant':
        return '/restaurant/$id';
      case 'experience':
        return '/experience/$id';
      case 'boutique':
        return '/boutique/$id';
      case 'vehicule':
        return '/vehicule/$id';
      default:
        return '/home';
    }
  }
}

/// Search state
class SearchState {
  final String query;
  final List<SearchResult> results;
  final bool isLoading;
  final bool hasSearched;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.hasSearched = false,
  });

  SearchState copyWith({
    String? query,
    List<SearchResult>? results,
    bool? isLoading,
    bool? hasSearched,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }
}

/// Semantic search notifier
class SemanticSearchNotifier extends StateNotifier<SearchState> {
  SemanticSearchNotifier() : super(const SearchState());

  /// Perform semantic search via pgvector
  Future<void> search(String query, {String? destinationId}) async {
    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(query: query, isLoading: true, hasSearched: true);

    try {
      final raw = await SupabaseService.semanticSearch(
        query: query,
        destinationId: destinationId,
        limit: 10,
      );
      final results = raw.map((m) => SearchResult.fromMap(m)).toList();
      state = state.copyWith(results: results, isLoading: false);
    } catch (_) {
      state = state.copyWith(results: [], isLoading: false);
    }
  }

  void clear() {
    state = const SearchState();
  }
}

final semanticSearchProvider =
    StateNotifierProvider<SemanticSearchNotifier, SearchState>((ref) {
  return SemanticSearchNotifier();
});
