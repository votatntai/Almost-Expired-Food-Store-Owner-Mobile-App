import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domains/repositories/feedback_repo.dart';
import 'feedback_state.dart';

final FeedbackRepo _feedbackRepo = getIt.get<FeedbackRepo>();

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackState());

  Future<void> feedback({required String productId, required int star, String? message}) async {
    try {
      emit(FeedbackLoadingState());
      var statusCode = await _feedbackRepo.feedback(star: star, productId: productId, message: message);
      emit(FeedbackSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(FeedbackFailedState(msg: e.toString()));
    }
  }
}

//Get Feedback
class GetFeedbackCubit extends Cubit<GetFeedbackState> {
  GetFeedbackCubit({required String productId, required String customerId}) : super(GetFeedbackState()) {
    getFeedback(productId: productId, customerId: customerId);
  }
  Future<void> getFeedback({required String productId, String? customerId}) async {
    try {
      emit(GetFeedbackLoadingState());
      var feedback = await _feedbackRepo.getFeedback(productId: productId, customerId: customerId);
      emit(GetFeedbackSuccessState(feedback: feedback));
    } on Exception catch (e) {
      emit(GetFeedbackFailedState(msg: e.toString()));
    }
  }
}
