import 'package:appetit/cubits/wallet/wallet_cubit.dart';
import 'package:appetit/cubits/wallet/wallet_state.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/Colors.dart';

class WalletScreen extends StatefulWidget {
  static const String routeName = '/wallet';
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _bankAccountController = TextEditingController();
  TextEditingController _amountWithdrawController = TextEditingController();
  int _balance = 0;
  late UpdateWalletCubit _updateWalletCubit;
  late WithdrawRequestCubit _withdrawRequestCubit;
  String _walletId = '';
  bool _isEditing = false;
  @override
  void initState() {
    _updateWalletCubit = BlocProvider.of<UpdateWalletCubit>(context);
    _withdrawRequestCubit = BlocProvider.of<WithdrawRequestCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appLayout_background,
      appBar: MyAppBar(
        title: 'Ví',
        actions: [
          _isEditing
              ? TextButton(
                  onPressed: () {
                    _updateWalletCubit.updateWallet(walletId: _walletId, bankName: _bankNameController.text, bankAccount: _bankAccountController.text);
                  },
                  child: Text(
                    'Lưu',
                    style: TextStyle(color: context.iconColor),
                  ))
              : TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: Text(
                    'Sửa',
                    style: TextStyle(color: context.iconColor),
                  ))
        ],
      ),
      body: BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
        if (state is WalletLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is WalletSuccessState) {
          var wallet = state.wallet;
          _bankNameController.text = wallet.bankName ?? '';
          _bankAccountController.text = wallet.bankAccount ?? '';
          _balance = wallet.balance!;
          _walletId = wallet.id!;
          return BlocListener<UpdateWalletCubit, UpdateWalletState>(
            listener: (context, state) {
              if (!(state is UpdateWalletLoadingState)) {
                Navigator.pop(context);
              }
              showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => ProcessingPopup(state: state));
            },
            child: BlocListener<WithdrawRequestCubit, WithdrawRequestState>(
              listener: (context, state) {
                if (!(state is UpdateWalletLoadingState)) {
                  Navigator.pop(context);
                }
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Dialog(
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.all(32.0),
                            child: Builder(builder: (context) {
                              if (state is WithdrawRequestLoadingState) {
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
                              if (state is WithdrawRequestSuccessState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Gửi yêu cầu rút tiền thành công'),
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
                        ));
              },
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          controller: _bankNameController,
                          readOnly: !_isEditing,
                          style: TextStyle(color: _isEditing ? context.iconColor : grey),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                            filled: true,
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: 'Tên ngân hàng*',
                            hintText: 'Nhập tên ngân hàng',
                          ),
                        ),
                      ),
                      Gap.k16.height,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: TextField(
                          controller: _bankAccountController,
                          readOnly: !_isEditing,
                          style: TextStyle(color: _isEditing ? context.iconColor : grey),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: appStore.isDarkModeOn ? context.cardColor : appetitAppContainerColor,
                            filled: true,
                            labelStyle: TextStyle(color: Colors.grey),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: 'Số tài khoản*',
                            hintText: 'Nhập số tài khoản',
                          ),
                        ),
                      ),
                      Gap.k16.height,
                      Text(
                        '(*): Bắt buộc nhập',
                        style: TextStyle(color: grey),
                      ),
                    ],
                  ).paddingAll(16),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: white),
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tổng số dư',
                                ),
                                Gap.k4.height,
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(text: FormatUtils.formatPrice(_balance.toDouble()), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: context.iconColor)),
                                  TextSpan(text: ' VND', style: TextStyle(color: context.iconColor))
                                ]))
                              ],
                            ),
                            _isEditing
                                ? SizedBox.shrink()
                                : Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(color: appetitAppContainerColor, borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'image/appetit/withdraw.png',
                                          height: 20,
                                        ),
                                        Gap.k8.width,
                                        Text('Rút', style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ).onTap(() {
                                    if (_bankNameController.text != '' && _bankAccountController.text != '') {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => WithdrawDialog(
                                                amountWithdrawController: _amountWithdrawController,
                                                callback: () async {
                                                  await _withdrawRequestCubit.withdrawRequest(amount: _amountWithdrawController.text.toInt());
                                                  Navigator.pop(context);
                                                },
                                              )).then((value) => value == true ? _amountWithdrawController.text = '' : null);
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                                                  Text('Cập nhật thông tin ví và thử lại'),
                                                  Gap.k16.height,
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text(
                                                        'Đóng',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ))
                                                ]).paddingAll(16),
                                              ));
                                    }
                                  })
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      }),
    );
  }
}

class WithdrawDialog extends StatefulWidget {
  final TextEditingController amountWithdrawController;
  final VoidCallback callback;
  const WithdrawDialog({
    Key? key,
    required this.amountWithdrawController,
    required this.callback,
  }) : super(key: key);

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  bool isAmountValid = false;

  @override
  void initState() {
    super.initState();
    widget.amountWithdrawController.addListener(_checkAmountValidation);
  }

  @override
  void dispose() {
    widget.amountWithdrawController.removeListener(_checkAmountValidation);
    super.dispose();
  }

  void _checkAmountValidation() {
    setState(() {
      isAmountValid = widget.amountWithdrawController.text.isNotEmpty && widget.amountWithdrawController.text.toInt() >= 50000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Gửi yêu cầu rút tiền',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Gap.k16.height,
            TextField(
              controller: widget.amountWithdrawController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'VND',
                labelText: 'Số tiền rút',
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            widget.amountWithdrawController.text.toInt() < 50000 && widget.amountWithdrawController.text.toInt() > 0
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap.k8.height,
                      Text(
                        'Tối thiểu 50,000 VND',
                        style: TextStyle(color: redColor, fontSize: 12),
                      )
                    ],
                  )
                : SizedBox.shrink(),
            Gap.k16.height,
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.orange.shade700), borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Text(
                      'Đóng',
                      style: TextStyle(color: Colors.orange.shade700),
                    )),
                  ).onTap(() {
                    Navigator.pop(context, true);
                  }),
                ),
                Gap.k8.width,
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: isAmountValid ? Colors.orange.shade700 : grey),
                        borderRadius: BorderRadius.circular(4),
                        color: isAmountValid ? Colors.orange.shade700 : grey),
                    child: Center(
                        child: Text(
                      'Gửi yêu cầu',
                      style: TextStyle(color: white),
                    )),
                  ).onTap(isAmountValid ? widget.callback : null),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final UpdateWalletState state;
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
          if (state is UpdateWalletLoadingState) {
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
          if (state is UpdateWalletSuccessState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Cập nhật ví thành công'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(WalletScreen.routeName);
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
