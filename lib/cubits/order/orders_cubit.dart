import 'package:appetit/cubits/order/orders_state.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domains/repositories/orders_repo.dart';

  final OrdersRepo _ordersRepo = getIt<OrdersRepo>();
class OrdersCubit extends Cubit<OrdersState> {

  OrdersCubit() :super(OrdersState());

  Future<void> getOrdersList({required String storeId, String? status, bool? isPayment}) async{
    try {
      emit(OrdersLoadingState());
      final orders = await _ordersRepo.getOrdersList(storeId: storeId, status: status, isPayment: isPayment);
      emit(OrdersSuccessState(orders: orders));
    } on Exception catch (e) {
      emit(OrdersFailedState(msg: e.toString()));
    }
  }
}

//Order details
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit({required String orderId}) :super(OrderDetailsState()){getOrderDetails(orderId: orderId);}
  Future<void> getOrderDetails({required String orderId}) async {
    try {
      emit(OrdersDetailsLoadingState());
      var order = await _ordersRepo.getOrderById(orderId: orderId);
      emit(OrderDetailsSuccessState(order: order));
    } on Exception catch (e) {
      emit(OrderDetailsFailedState(msg: e.toString()));
    }
  }
}