import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tuplive/core/constants/enums.dart';
import 'package:tuplive/core/constants/routes_enum.dart';
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
          return ListView.builder(
            itemCount: state.configs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.configs[index].roomID),
                onTap: () {
                  GetIt.instance<LiveStreamBloc>().add(
                    JoinRoom(
                      sdp: state.configs[index].sdp,
                      roomID: state.configs[index].roomID,
                      candidate: state.configs[index].candidate,
                    ),
                  );
                  GetIt.instance<GoRouter>().pushNamed(
                    Routes.liveStream.subname(Routes.home.name),
                    params: {
                      'id': state.configs[index].roomID,
                    },
                  );
                },
              );
            },
          );
        }

        return const Placeholder(
          child: Text('home'),
        );
      },
    );
  }
}
