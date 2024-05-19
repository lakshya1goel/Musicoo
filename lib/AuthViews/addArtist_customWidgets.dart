import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicoo/constants/constants.dart';

class Genre extends ConsumerStatefulWidget {
  Genre({super.key, this.genrename, this.id, required this.change});
  final genrename;
  final id;
  final dynamic Function(int) change;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenreState();
}

class _GenreState extends ConsumerState<Genre> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(top: 16),
      child: InkWell(
        onTap: () {
          setState(() {
            clicked = !clicked;
            widget.change(widget.id);
          });
        },
        child: Container(
          height: getVerticalSize(54),
          width: getHorizontalSize(312),
          decoration: BoxDecoration(
              border: clicked ? Border.all(color: Color(0xFF92E3A9)) : null,
              color: Color(0xFF333333),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 54,
                height: 54,
              ),
              Text(
                widget.genrename,
                style: TextStyle(
                    color: clicked ? Color(0xFF92E3A9) : Colors.white),
              ),
              Container(
                // color: Colors.amber,
                width: 54,
                height: 54,
                child: (clicked)
                    ? Center(
                        child: Icon(
                          Icons.check,
                          color: Color(0xFF92E3A9),
                        ),
                      )
                    : null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
