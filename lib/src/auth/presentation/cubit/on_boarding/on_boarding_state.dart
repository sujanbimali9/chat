part of 'on_boarding_cubit.dart';

@immutable
class OnBoardingState {
  final int currentPage;
  final bool isLastPage;
  const OnBoardingState({
    required this.currentPage,
    required this.isLastPage,
  });

  OnBoardingState copyWith({
    int? currentPage,
    bool? isLastPage,
  }) {
    return OnBoardingState(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

final class OnBoardingComplete extends OnBoardingState {
  const OnBoardingComplete() : super(currentPage: 3, isLastPage: true);
}
