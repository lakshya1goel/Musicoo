import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicoo/providers.dart';

class ForgotPassword extends ConsumerWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/Frame1.png',
                  height: MediaQuery.of(context).size.height * 0.405,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Image.asset('assets/LOGO.png'),
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.594 - 29,
              child: ref.watch(forgot),
            )
          ],
        ),
      ),
    ));
  }
}
