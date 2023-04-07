// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_it/get_it.dart';
import 'package:tuplive/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:tuplive/features/LiveStream/presentation/bloc/livestream_bloc.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({
    Key? key,
    this.isStreamer = true,
  }) : super(key: key);
  final bool isStreamer;

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
      StopStreamingEvent(isStreamer: widget.isStreamer),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: GetIt.instance<AuthCubit>(),
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          GetIt.instance<LiveStreamBloc>().add(
            CreateRoomEvent(user: state.user!),
          );
        }
      },
      child: BlocBuilder<LiveStreamBloc, LiveStreamState>(
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
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
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
                final authCubit = GetIt.instance<AuthCubit>();
                if (authCubit.state.status == LoginStatus.success) {
                  GetIt.instance<LiveStreamBloc>().add(
                    CreateRoomEvent(user: authCubit.state.user!),
                  );
                } else {
                  authCubit.login();
                }
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
      ),
    );
  }
}
