import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/services/providers/note_provider.dart';

part 'search_provider.g.dart';

/// Search query provider
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() {
    return '';
  }

  void setQuery(String query) {
    state = query.toLowerCase().trim();
  }
}
