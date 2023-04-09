import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tuplive/core/constants/enums.dart';
import 'package:tuplive/core/constants/grid.dart';
import 'package:tuplive/core/constants/routes_enum.dart';
import 'package:tuplive/core/presentation/widgets/spacers.dart';
import 'package:tuplive/features/LiveStream/presentation/bloc/livestream_bloc.dart';
import 'package:tuplive/features/LiveStream/presentation/cubit/active_streams_cubit.dart';

class StreamListPage extends StatelessWidget {
  const StreamListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveStreamsCubit, ActiveStreamsState>(
      bloc: GetIt.instance<ActiveStreamsCubit>(),
      builder: (context, state) {
        if (state.status == StateStatus.loaded && state.configs.isNotEmpty) {
          return Wrap(
            children: [
              ...state.configs.map((stream) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppGrid.large,
                      vertical: AppGrid.medium,
                    ),
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Tooltip(
                            message: stream.viewersCount > 0
                                ? '${stream.viewersCount} ${stream.viewersCount > 1 ? 'people are' : 'person is'} watching'
                                : 'No one is watching',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.visibility),
                                HorizontalSpacers.small,
                                Text(stream.viewersCount.toString()),
                              ],
                            ),
                          ),
                        ),
                        Text(stream.user.name),
                        VerticalSpacers.medium,
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(
                                stream.user.profileImgUrl,
                              ),
                            ),
                          ),
                        ),
                        VerticalSpacers.medium,
                        FilledButton(
                          onPressed: () {
                            GetIt.instance<LiveStreamBloc>().add(
                              JoinRoom(
                                sdp: stream.sdp,
                                roomID: stream.roomID,
                                candidate: stream.candidate,
                              ),
                            );
                            GetIt.instance<GoRouter>().pushNamed(
                              Routes.liveStream.subname(Routes.home.name),
                              params: {
                                'id': stream.roomID,
                              },
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Watch'),
                              HorizontalSpacers.small,
                              Icon(Icons.tv_rounded),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.no_accounts_rounded,
              size: 128,
              color: Theme.of(context).colorScheme.primary.withOpacity(.5),
            ),
            VerticalSpacers.medium,
            Text(
              'No streamers at this time.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.5),
                  ),
            ),
            VerticalSpacers.medium,
            TextButton(
              onPressed: () {
                GetIt.instance<GoRouter>().pushNamed(
                    Routes.liveStream.subname(Routes.home.name),
                    params: {'id': 'stream'});
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppGrid.small),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Go Live',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    HorizontalSpacers.small,
                    Icon(
                      Icons.live_tv_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
