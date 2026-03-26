import 'package:bubbly/modal/live_stream/live_stream.dart';
import 'package:bubbly/view/live_stream/model/broad_cast_screen_view_model.dart';
import 'package:bubbly/view/live_stream/widget/audience_top_bar.dart';
import 'package:bubbly/view/live_stream/widget/live_stream_bottom_filed.dart';
import 'package:bubbly/view/live_stream/widget/live_stream_chat_list.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AudienceScreen extends StatelessWidget {
  final String? agoraToken;
  final String? channelName;
  final LiveStreamUser user;

  const AudienceScreen({
    Key? key,
    this.agoraToken,
    this.channelName,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BroadCastScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init(
          isBroadCast: false,
          agoraToken: agoraToken ?? '',
          channelName: channelName ?? '',
        );
      },
      viewModelBuilder: () => BroadCastScreenViewModel(),
      builder: (context, model, child) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: Stack(
              children: [
                model.videoPanel(),
                SafeArea(
                  child: Column(
                    children: [
                      AudienceTopBar(model: model, user: user),
                      Spacer(),
                      LiveStreamChatList(
                          commentList: model.commentList, pageContext: context),
                      LiveStreamBottomField(model: model)
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
