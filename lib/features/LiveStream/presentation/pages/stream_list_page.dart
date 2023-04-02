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
              ...state.configs.map((e) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      GetIt.instance<LiveStreamBloc>().add(
                        JoinRoom(
                          sdp: e.sdp,
                          roomID: e.roomID,
                          candidate: e.candidate,
                        ),
                      );
                      GetIt.instance<GoRouter>().pushNamed(
                        Routes.liveStream.subname(Routes.home.name),
                        params: {
                          'id': e.roomID,
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppGrid.large,
                        vertical: AppGrid.medium,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Streamer - ${state.configs.indexOf(e) + 1}',
                          ),
                          VerticalSpacers.medium,
                          CircleAvatar(
                            maxRadius: 40,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
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
