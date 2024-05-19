import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicoo/AuthViews/addArtist_customWidgets.dart';
import 'package:musicoo/AuthViews/addArtist_provider.dart';
import 'package:musicoo/constants/constants.dart';

class Addartist extends ConsumerWidget {
  Addartist({super.key});
  Map<int, bool> genre_map = {};
  changegenre(int id) {
    if (genre_map[id] == null) {
      genre_map[id] = true;
      log(genre_map.toString());
      return;
    }
    genre_map[id] = !genre_map[id]!;
    log(genre_map.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(artistProvider);
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: getPadding(all: 24),
              child: SizedBox(
                  height: getVerticalSize(38),
                  width: getHorizontalSize(93),
                  child: Image.asset('assets/LOGO.png')),
            ),
            Padding(
              padding: getPadding(top: 16),
              child: Container(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Pick Your Genre',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 8),
                        child: Text(
                          'Pick at least 5 topics',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getVerticalSize(420),
                        width: getHorizontalSize(312),
                        child: data.when(
                          data: (data) {
                            log(data.toString());

                            return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: ((context, index) {
                                  String genrename = data[index][1];
                                  int genreid = data[index][0];
                                  return Genre(
                                      genrename: genrename,
                                      id: genreid,
                                      change: changegenre);
                                }));
                          },
                          error: ((error, stackTrace) {}),
                          loading: () {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 36),
                        child: ElevatedButton(
                            onPressed: (() {
                              List<int> genre_list = [];
                              genre_map.forEach((key, value) {
                                if (value == true) {
                                  genre_list.add(key);
                                }
                              });
                              log(genre_list.toString());
                              if (genre_list.length < 5) {
                                return;
                              }
                              ref.watch(genre.notifier).state=genre_list;
                              context.go('/addartists2');
                            }),
                            child: Container(
                                height: getVerticalSize(54),
                                width: getHorizontalSize(312),
                                child: Center(
                                    child: Text(
                                  'Next',
                                  style: TextStyle(color: Colors.black),
                                )))),
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
