import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porichoy/features/discover/domain/user_profile.dart';
import 'package:porichoy/features/discover/data/mock_profiles.dart';
import 'package:porichoy/features/matches/domain/match_model.dart';

class DiscoverState {
  final List<UserProfile> candidates;
  final List<UserProfile> swipedHistory;
  final List<MatchModel> matches;
  final Set<String> unblurredProfileIds; // Temporary preview toggle
  final String? filterDivision;
  final String? filterIntent;
  final bool isLoading;

  const DiscoverState({
    this.candidates = const [],
    this.swipedHistory = const [],
    this.matches = const [],
    this.unblurredProfileIds = const {},
    this.filterDivision,
    this.filterIntent,
    this.isLoading = false,
  });

  DiscoverState copyWith({
    List<UserProfile>? candidates,
    List<UserProfile>? swipedHistory,
    List<MatchModel>? matches,
    Set<String>? unblurredProfileIds,
    String? filterDivision,
    String? filterIntent,
    bool? isLoading,
  }) {
    return DiscoverState(
      candidates: candidates ?? this.candidates,
      swipedHistory: swipedHistory ?? this.swipedHistory,
      matches: matches ?? this.matches,
      unblurredProfileIds: unblurredProfileIds ?? this.unblurredProfileIds,
      filterDivision: filterDivision ?? this.filterDivision,
      filterIntent: filterIntent ?? this.filterIntent,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DiscoverNotifier extends Notifier<DiscoverState> {
  @override
  DiscoverState build() {
    return DiscoverState(
      candidates: List.from(kSampleBangladeshiProfiles),
    );
  }

  void loadProfiles() {
    state = state.copyWith(
      candidates: List.from(kSampleBangladeshiProfiles),
      isLoading: false,
    );
  }

  /// Swipes Right (Like) - Checks for mutual match
  MatchModel? swipeLike(UserProfile profile) {
    if (state.candidates.isEmpty) return null;

    final updatedCandidates = List<UserProfile>.from(state.candidates)..removeWhere((p) => p.id == profile.id);
    final updatedHistory = List<UserProfile>.from(state.swipedHistory)..add(profile);

    MatchModel? newMatch;
    // Simulate high likelihood of mutual match for demo engagement
    if (profile.id == 'user_01' || profile.id == 'user_03') {
      newMatch = MatchModel(
        id: 'match_${profile.id}',
        partner: profile,
        matchedAt: DateTime.now(),
        lastMessagePreview: 'You both connected with meaning!',
        isPhotoRevealed: false,
      );
    }

    final updatedMatches = newMatch != null
        ? (List<MatchModel>.from(state.matches)..insert(0, newMatch))
        : state.matches;

    state = state.copyWith(
      candidates: updatedCandidates,
      swipedHistory: updatedHistory,
      matches: updatedMatches,
    );

    return newMatch;
  }

  /// Swipes Left (Pass)
  void swipePass(UserProfile profile) {
    if (state.candidates.isEmpty) return;

    final updatedCandidates = List<UserProfile>.from(state.candidates)..removeWhere((p) => p.id == profile.id);
    final updatedHistory = List<UserProfile>.from(state.swipedHistory)..add(profile);

    state = state.copyWith(
      candidates: updatedCandidates,
      swipedHistory: updatedHistory,
    );
  }

  /// Super Like (Star)
  MatchModel swipeSuperlike(UserProfile profile) {
    final updatedCandidates = List<UserProfile>.from(state.candidates)..removeWhere((p) => p.id == profile.id);
    final updatedHistory = List<UserProfile>.from(state.swipedHistory)..add(profile);

    final instantMatch = MatchModel(
      id: 'match_super_${profile.id}',
      partner: profile,
      matchedAt: DateTime.now(),
      lastMessagePreview: 'You sent a Super-Like! Stand out with a prompt reply.',
      isPhotoRevealed: true,
    );

    state = state.copyWith(
      candidates: updatedCandidates,
      swipedHistory: updatedHistory,
      matches: List<MatchModel>.from(state.matches)..insert(0, instantMatch),
    );

    return instantMatch;
  }

  /// Undo last swipe
  void undoSwipe() {
    if (state.swipedHistory.isEmpty) return;

    final lastSwiped = state.swipedHistory.last;
    final updatedHistory = List<UserProfile>.from(state.swipedHistory)..removeLast();
    final updatedCandidates = List<UserProfile>.from(state.candidates)..insert(0, lastSwiped);

    state = state.copyWith(
      candidates: updatedCandidates,
      swipedHistory: updatedHistory,
    );
  }

  /// Toggle temporary discreet unblur preview
  void toggleTemporaryUnblur(String profileId) {
    final updated = Set<String>.from(state.unblurredProfileIds);
    if (updated.contains(profileId)) {
      updated.remove(profileId);
    } else {
      updated.add(profileId);
    }
    state = state.copyWith(unblurredProfileIds: updated);
  }

  /// Filter candidates
  void applyFilters({String? division, String? intent}) {
    state = state.copyWith(
      filterDivision: division,
      filterIntent: intent,
    );
  }
}

final discoverProvider = NotifierProvider<DiscoverNotifier, DiscoverState>(DiscoverNotifier.new);
