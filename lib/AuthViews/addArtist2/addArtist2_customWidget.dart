import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Artist extends ConsumerStatefulWidget {
  const Artist(
      {super.key,
      this.firstname,
      this.lastname,
      this.id,
      required this.change});
  final firstname;
  final lastname;
  final id;
  final dynamic Function(int) change;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArtistState();
}

class _ArtistState extends ConsumerState<Artist> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            clicked = !clicked;
            widget.change(widget.id);
          });
        },
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://assets-in.bmscdn.com/iedb/artist/images/website/poster/large/arijit-singh-1048083-24-03-2017-18-02-00.jpg'),
                  ),
                  Container(
                    child: clicked
                        ? Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(155, 0, 0, 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1000))),
                            child: Icon(
                              Icons.check,
                              size: 30,
                            ),
                          )
                        : null,
                  )
                ],
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(
              //           Radius.circular(100))),
              //   child: Image.network(
              //       'https://assets-in.bmscdn.com/iedb/artist/images/website/poster/large/arijit-singh-1048083-24-03-2017-18-02-00.jpg'),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${widget.firstname} ${widget.lastname}',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
