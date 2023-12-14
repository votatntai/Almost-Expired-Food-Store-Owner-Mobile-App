import '../../domains/models/orders.dart';

class OrdersState {}

class OrdersLoadingState extends OrdersState {}

class OrdersFailedState extends OrdersState {
  final String msg;
  OrdersFailedState({required this.msg});
}

class OrdersSuccessState extends OrdersState {
  final Orders orders;
  OrdersSuccessState({required this.orders});
}

//Order details
class OrderDetailsState {}

class OrdersDetailsLoadingState extends OrderDetailsState {}

class OrderDetailsFailedState extends OrderDetailsState {
  final String msg;
  OrderDetailsFailedState({required this.msg});
}

class OrderDetailsSuccessState extends OrderDetailsState {
  final Order order;
  OrderDetailsSuccessState({required this.order});
}