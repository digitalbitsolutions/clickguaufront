import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/view/live_stream/model/broad_cast_screen_view_model.dart';
import 'package:bubbly/view/live_stream/widget/broad_cast_top_bar_area.dart';
import 'package:bubbly/view/live_stream/widget/live_stream_bottom_filed.dart';
import 'package:bubbly/view/live_stream/widget/live_stream_chat_list.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BroadCastScreen extends StatelessWidget {
  final String? agoraToken;
  final String? channelName;
  final User? registrationUser;

  const BroadCastScreen({
    Key? key,
    required this.agoraToken,
    required this.channelName,
    this.registrationUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BroadCastScreenViewModel>.reactive(
      onViewModelReady: (model) {
        return model.init(
            isBroadCast: true,
            agoraToken: agoraToken ?? "",
            channelName: channelName ?? '',
            registrationUser: registrationUser);
      },
      onDispose: (viewModel) {
        viewModel.leave();
      },
      viewModelBuilder: () => BroadCastScreenViewModel(),
      builder: (context, model, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            model.onEndButtonClick();
          },
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: model.videoPanel(),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      BroadCastTopBarArea(model: model),
                      Spacer(),
                      LiveStreamChatList(
                          commentList: model.commentList, pageContext: context),
                      LiveStreamBottomField(
                        model: model,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
