import 'package:appetit/cubits/notification/notification_state.dart';
import 'package:appetit/domains/repositories/notification_repo.dart';
import 'package:appetit/utils/Constants.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

  final NotificationRepo _notificationRepo = getIt<NotificationRepo>();
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() :super(NotificationState());

  Future<void> getNotifications() async {
    try {
      emit(NotificationLoadingState());
      var notifications = await _notificationRepo.getNotifications();
      setValue(AppConstant.NOTI_COUNT, notifications.notifications!.length);
      emit(NotificationSuccessState(notifications: notifications));
    } on Exception catch (e) {
      emit(NotificationFaildState(msg: e.toString()));
    }
  }
}

class MarkAsReadNotificationCubit extends Cubit<MarkAsReadNotificationState> {
  MarkAsReadNotificationCubit() :super(MarkAsReadNotificationState());

  Future<void> markAsRead({required String notificationId}) async {
    try {
      emit(MarkAsReadNotificationLoadingState());
      var statusCode = await _notificationRepo.markAsRead(notificationId: notificationId);
      emit(MarkAsReadNotificationSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(MarkAsReadNotificationFaildState(msg: e.toString()));
    }
  }
}
