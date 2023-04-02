// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_it/get_it.dart';
import 'package:tuplive/features/LiveStream/presentation/bloc/livestream_bloc.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    GetIt.instance<LiveStreamBloc>().add(
      const StopStreamingEvent(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveStreamBloc, LiveStreamState>(
      bloc: GetIt.instance<LiveStreamBloc>(),
      builder: (context, state) {
        if (state is LiveStreamReady) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.roomID),
                Container(
                  height: 400,
                  width: 499,
                  color: Theme.of(context).primaryColor.withOpacity(.5),
                  child: RTCVideoView(
                    state.videoRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    mirror: true,
                    placeholderBuilder: (context) {
                      return const CircularProgressIndicator.adaptive();
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: TextButton(
            onPressed: () {
              GetIt.instance<LiveStreamBloc>().add(const CreateRoomEvent());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Go Live'),
                Icon(Icons.live_tv_rounded),
              ],
            ),
          ),
        );
      },
    );
  }
}
