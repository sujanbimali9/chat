part of 'terms_condition_cubit.dart';

@immutable
class TermsConditionState {
  final bool isAccepted;

  const TermsConditionState({required this.isAccepted});

  TermsConditionState copyWith({
    bool? isAccepted,
  }) {
    return TermsConditionState(
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }
}
