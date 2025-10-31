// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notesRepository)
const notesRepositoryProvider = NotesRepositoryProvider._();

final class NotesRepositoryProvider
    extends
        $FunctionalProvider<NotesRepository, NotesRepository, NotesRepository>
    with $Provider<NotesRepository> {
  const NotesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotesRepository create(Ref ref) {
    return notesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotesRepository>(value),
    );
  }
}

String _$notesRepositoryHash() => r'7c6b703997e054b28f9a92cc8473da92a76728cb';

@ProviderFor(NotesNotifier)
const notesProvider = NotesNotifierProvider._();

final class NotesNotifierProvider
    extends $AsyncNotifierProvider<NotesNotifier, List<NoteModel>> {
  const NotesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesNotifierHash();

  @$internal
  @override
  NotesNotifier create() => NotesNotifier();
}

String _$notesNotifierHash() => r'c5e6ec91a343222d69be494b9e31158abc34c638';

abstract class _$NotesNotifier extends $AsyncNotifier<List<NoteModel>> {
  FutureOr<List<NoteModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<NoteModel>>, List<NoteModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<NoteModel>>, List<NoteModel>>,
              AsyncValue<List<NoteModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
