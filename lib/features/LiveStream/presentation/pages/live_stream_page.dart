// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_it/get_it.dart';
import 'package:tuplive/core/constants/grid.dart';
import 'package:tuplive/core/dependencies/dependencies.dart';
import 'package:tuplive/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:tuplive/features/Comment/presentation/widgets/comment_section_widget.dart';
import 'package:tuplive/features/LiveStream/presentation/bloc/livestream_bloc.dart';
import 'package:tuplive/features/LiveStream/presentation/cubit/active_streams_cubit.dart';
import 'package:tuplive/features/LiveStream/presentation/widgets/viewers_count_widget.dart';

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
        final liveStreamState = serviceLocator<LiveStreamBloc>().state;
        if (state.status == LoginStatus.success &&
            liveStreamState is LivestreamInitial) {
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
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor.withOpacity(.5),
                          child: RTCVideoView(
                            state.videoRenderer,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitContain,
                            mirror: true,
                            placeholderBuilder: (context) {
                              return const CircularProgressIndicator.adaptive();
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: AppGrid.small,
                              right: AppGrid.small,
                            ),
                            child: _buildViewersCount(state.roomID),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CommentSectionWidget(
                      roomID: state.roomID,
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

  Widget _buildViewersCount(
    String roomID,
  ) {
    return BlocSelector<ActiveStreamsCubit, ActiveStreamsState, int>(
      bloc: serviceLocator<ActiveStreamsCubit>(),
      selector: (state) {
        return state.configs
            .firstWhere(
              (config) => roomID == config.roomID,
            )
            .viewersCount;
      },
      builder: (context, viewersCount) {
        return ViewersCountWidget(
          count: viewersCount,
        );
      },
    );
  }
}
