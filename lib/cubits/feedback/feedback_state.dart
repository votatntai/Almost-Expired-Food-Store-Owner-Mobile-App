import '../../domains/models/feedback.dart';

class FeedbackState {}

class FeedbackLoadingState extends FeedbackState {}

class FeedbackFailedState extends FeedbackState {
  final String msg;
  FeedbackFailedState({required this.msg});
}

class FeedbackSuccessState extends FeedbackState {
  final int statusCode;
  FeedbackSuccessState({required this.statusCode});
}

//Get feedback
class GetFeedbackState {}

class GetFeedbackLoadingState extends GetFeedbackState {}

class GetFeedbackFailedState extends GetFeedbackState {
  final String msg;
  GetFeedbackFailedState({required this.msg});
}

class GetFeedbackSuccessState extends GetFeedbackState {
  final Feedback feedback;
  GetFeedbackSuccessState({required this.feedback});
}
