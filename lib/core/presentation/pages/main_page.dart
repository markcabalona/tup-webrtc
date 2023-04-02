// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tuplive/core/constants/routes_enum.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    Key? key,
    this.body,
    this.appBar,
  }) : super(key: key);
  final Widget? body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            automaticallyImplyLeading: true,
            actions: [
              TextButton(
                onPressed: () {
                  GetIt.instance<GoRouter>().pushNamed(
                      Routes.liveStream.subname(Routes.home.name),
                      params: {'id': '1'});
                },
                child: const Icon(Icons.live_tv_rounded),
              ),
            ],
          ),
      body: body,
    );
  }
}
