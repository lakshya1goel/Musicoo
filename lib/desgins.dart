import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

late final eye = StateProvider<bool?>((ref) => true);

class CTextField extends ConsumerWidget {
  CTextField(
      {super.key,
      this.hinttext,
      this.width = 312,
      this.hidden,
      this.icon,
      required this.onChanged,
      this.controller,
      required this.validator});
  final String? hinttext;
  final int width;
  final String? Function(String?) validator;
  final Function(String?) onChanged;

  final controller;
  final bool? hidden;
  final icon;

  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      height: 82,
      width: 312,
      child: Center(
        child: TextFormField(
          onChanged: onChanged,
          maxLength: 50,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // validator: validator,
          obscureText: ref.watch(eye) ?? false,
          maxLines: 1,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: icon,
            suffixIcon:
                (hinttext == 'Password' || hinttext == "Confirm Password")
                    ? IconButton(
                        onPressed: () {
                          ref.read(eye.notifier).state =
                              !(ref.read(eye.notifier).state ?? true);
                        },
                        icon: Icon(
                          (!(ref.watch(eye) ?? false))
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      )
                    : null,
            contentPadding: const EdgeInsets.all(10),
            counterText: '',
            hintText: hinttext,
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

const MaterialColor mainColor = MaterialColor(
  _bluePrimaryValue,
  <int, Color>{
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(_bluePrimaryValue),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  },
);
const int _bluePrimaryValue = 0xFF92E3A9;

class CText extends StatelessWidget {
  const CText({
    super.key,
    this.size,
    required this.t,
  });
  final size;
  final String t;
  @override
  Widget build(BuildContext context) {
    return Text(
      t,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(fontSize: size, fontWeight: FontWeight.w500)),
    );
  }
}
