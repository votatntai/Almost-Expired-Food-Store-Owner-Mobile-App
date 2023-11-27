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