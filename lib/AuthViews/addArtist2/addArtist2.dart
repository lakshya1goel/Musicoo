import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicoo/AuthViews/addArtist2/addArtist2_customWidget.dart';
import 'package:musicoo/AuthViews/addArtist2/addArtist2_provider.dart';
import 'package:musicoo/AuthViews/addArtist2/addArtist2_services.dart';
import 'package:musicoo/AuthViews/addArtist_provider.dart';
import 'package:musicoo/AuthViews/addArtist_services.dart';
import 'package:musicoo/constants/constants.dart';

class Addartist2 extends ConsumerWidget {
  Addartist2({super.key});
  Map<int, bool> artist_map = {};
  changeartist(int id) {
    if (artist_map[id] == null) {
      artist_map[id] = true;
      log(artist_map.toString());
      return;
    }
    artist_map[id] = !artist_map[id]!;
    log(artist_map.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(artist2Provider);
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      'Pick Some Artists You Like',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    Padding(
                      padding: getPadding(top: 8),
                      child: Text(
                        'Pick at least 5 Artists',
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
                          return GridView.builder(
                            itemCount: data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, childAspectRatio: 0.65),
                            itemBuilder: (context, index) {
                              return Artist(
                                firstname: data[index][1],
                                lastname: data[index][2],
                                id: data[index][0],
                                change: changeartist,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) {},
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
                          onPressed: (() async {
                            List<int> artist_list = [];
                            artist_map.forEach((key, value) {
                              if (value == true) {
                                artist_list.add(key);
                              }
                            });
                            log(artist_list.toString());
                            if (artist_list.length < 5) {
                              return;
                            }
                            ref.watch(artist.notifier).state = artist_list;
                            AddArtist2api api = AddArtist2api();
                            final List<dynamic> artist_list_1 =
                                ref.watch(artist.notifier).state;
                            final List<dynamic> genre_list_1 =
                                ref.watch(genre.notifier).state;
                            dynamic res = await api.submitchoices(
                                artist_list_1, genre_list_1);
                            if (res == "recall") {
                              res = await api.submitchoices(
                                  artist_list_1, genre_list_1);
                            }
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
        ]),
      ),
    );
  }
}
