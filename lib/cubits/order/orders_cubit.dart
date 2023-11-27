import 'package:appetit/cubits/order/orders_state.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domains/repositories/orders_repo.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo _ordersRepo = getIt<OrdersRepo>();

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
