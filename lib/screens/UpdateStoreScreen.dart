import 'package:appetit/cubits/store/stores_cubit.dart';
import 'package:appetit/domains/repositories/stores_repo.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../cubits/store/stores_state.dart';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/gap.dart';
import 'DashboardScreen.dart';

class UpdateStoreScreen extends StatefulWidget {
  static const String routeName = '/update-store';
  const UpdateStoreScreen({Key? key}) : super(key: key);

  @override
  State<UpdateStoreScreen> createState() => _UpdateStoreScreenState();
}

class _UpdateStoreScreenState extends State<UpdateStoreScreen> {
    TextEditingController _storeName = TextEditingController();
  TextEditingController _description = TextEditingController();
  late UpdateStoreCubit _updateStoreCubit;

  @override
  void initState(){
    _updateStoreCubit = BlocProvider.of<UpdateStoreCubit>(context);
    _storeName.text = StoresRepo.store.name!;
    _description.text = StoresRepo.store.description!;
    super.initState();
  }

  @override
  void dispose() {
    _storeName.dispose();
    _description.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Cập nhật cửa hàng',
      ),
      body: BlocListener<UpdateStoreCubit, UpdateStoreState>(
        listener: (context, state) {
          if (!(state is UpdateStoreLoadingState)) {
            Navigator.pop(context);
          }
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ProcessingPopup(
                  state: state,
                );
              });
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextField(
                        controller: _storeName,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                          filled: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Tên cửa hàng*',
                          hintText: 'Nhập tên cửa hàng',
                        ),
                      ),
                    ),
                    Gap.k16.height,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextField(
                        maxLines: null,
                        controller: _description,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                          filled: true,
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: 'Mô tả về cửa hàng của bạn*',
                          hintText: 'Nhập mô tả cửa hàng',
                        ),
                      ),
                    ),
                    Gap.k16.height,
                    Text(
                      '(*): Bắt buộc nhập',
                      style: TextStyle(color: grey),
                    )
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: (_storeName.text != '' && _description.text != '' && !(MediaQuery.of(context).viewInsets.bottom > 0))
                      ? ElevatedButton(
                          onPressed: () async {
                            await _updateStoreCubit.updateStore(storeId: StoresRepo.store.id!, name: _storeName.text, description: _description.text);
                            StoresRepo.store = await StoresRepo().getStoresByOwner().then((value) => value.stores!.first);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Lưu', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange.shade600,
                            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final UpdateStoreState state;
  const ProcessingPopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(32.0),
        child: Builder(builder: (context) {
          if (state is UpdateStoreLoadingState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Gap.k16.height,
                Text('Đang xử lý, vui lòng chờ.')
              ],
            );
          }
          if (state is UpdateStoreSuccessState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Tạo cửa hàng thành công'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => DashboardScreen(
                                tabIndex: 2,
                              )));
                    },
                    child: Text(
                      'Đóng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Đã xãy ra sự cố, hãy thử lại'),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Đóng',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          );
        }),
      ),
    );
  }
}
