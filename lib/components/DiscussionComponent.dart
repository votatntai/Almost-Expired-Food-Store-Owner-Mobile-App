import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/SkeletonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../cubits/feedback/feadback_cubit.dart';
import '../cubits/feedback/feedback_state.dart';

class DiscussionComponent extends StatefulWidget {
  final String productId;
  const DiscussionComponent({Key? key, required this.productId}) : super(key: key);

  @override
  State<DiscussionComponent> createState() => _DiscussionComponentState();
}

class _DiscussionComponentState extends State<DiscussionComponent> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetFeedbackCubit>(
      create: (context) => GetFeedbackCubit(productId: widget.productId, customerId: ''),
      child: BlocBuilder<GetFeedbackCubit, GetFeedbackState>(builder: (context, state) {
        if (state is GetFeedbackLoadingState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //User Information
              Row(
                children: [SkeletonWidget(borderRadius: 25, height: 35, width: 35), SizedBox(width: 8), SkeletonWidget(borderRadius: 8, height: 20, width: 100)],
              ),

              //User Comment with likes and reply
              Padding(
                padding: EdgeInsets.only(left: 43.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //comment
                    SkeletonWidget(borderRadius: 8, height: 20, width: 300),
                  ],
                ),
              ),
            ],
          ).paddingSymmetric(vertical: 8);
        }
        if (state is GetFeedbackSuccessState) {
          var feedback = state.feedback.data;
          if (feedback!.isNotEmpty) {
            
          return Column(
            children: feedback.map((e) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //User Information
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: FadeInImage.assetNetwork(image: e.customer!.avatarUrl!, placeholder: 'image/appetit/avatar_placeholder.png', fit: BoxFit.cover, width: 35, height: 35),
                  ),
                  Gap.k16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 8),
                      Text(e.customer!.name!, style: TextStyle(fontWeight: FontWeight.w700)),
                      e.message != '' ? Text(
                        e.message!,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ) : SizedBox.shrink(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Wrap(
                            children: List.generate(
                              e.star!,
                              (index) => Icon(
                                Icons.star_rate,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                          Wrap(
                            children: List.generate(
                              5 - e.star!,
                              (index) => Icon(
                                Icons.star_rate_outlined,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).expand(),

                  //User Comment with likes and reply
                ],
              ).paddingSymmetric(vertical: 8);
            }).toList(),
          );
          } else {
            return Text('Chưa có đánh giá');
          }
        }
        return SizedBox.shrink();
      }
      ),
    );
  }
}
