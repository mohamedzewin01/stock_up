//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../resources/color_manager.dart';
//
//
//
// class AppThemes {
//   static final lightTheme1 = ThemeData(
//     primarySwatch: Colors.deepPurple, // You can customize this
//     scaffoldBackgroundColor: ColorManager.appBackground,
//     fontFamily: 'Poppins', // Example: Add a custom font
//     textTheme: const TextTheme(
//       headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//       titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),
//       titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
//       bodyLarge: TextStyle(fontSize: 16, color: Colors.black54),
//       bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
//       labelLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//     ),
//     colorScheme: ColorScheme.fromSwatch().copyWith(
//       secondary: const Color(0xFFE0F7FA), // Light cyan for some backgrounds
//       primary:  ColorManager.primaryColor, // A teal-ish primary
//     ),
//
//     // colorScheme: ColorScheme.light(
//     //   surface: Colors.white,
//     //   // background: Colors.white,
//     //   primary: Color(0xff98A2B3),
//     //   secondary: Colors.grey[300]!,
//     // ),
//     // primaryColor: const Color(0xff2382AA),
//     // bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     //     backgroundColor: Color(0xff2382AA),
//     //     selectedItemColor: const Color(0xff2382AA),
//     //     unselectedItemColor: Color.fromARGB(255, 176, 176, 176),
//     //     type: BottomNavigationBarType.shifting),
//     // scaffoldBackgroundColor: Colors.white,
//     // cardColor: Color(0xffE9F5FA),
//     // textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
//     // brightness: Brightness.light,
//     // appBarTheme: AppBarTheme(
//     //   scrolledUnderElevation: 0,
//     //   surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
//     //   backgroundColor: Color.fromARGB(255, 255, 255, 255),
//     // ),
//     // inputDecorationTheme: InputDecorationTheme(
//     //   enabledBorder: OutlineInputBorder(
//     //       borderRadius: BorderRadius.circular(AppSize.s10),
//     //       borderSide: BorderSide(width: 1, color: Color(0xff181842))),
//     //   focusedBorder: OutlineInputBorder(
//     //     borderRadius: BorderRadius.circular(8.0),
//     //     borderSide: BorderSide(width: 1, color: Color(0xff5e95ac)),
//     //   ),
//     //   // constraints: BoxConstraints.expand(height: 48),
//     // ),
//     // dropdownMenuTheme: DropdownMenuThemeData(
//     //     inputDecorationTheme: InputDecorationTheme(
//     //       enabledBorder: OutlineInputBorder(
//     //         borderRadius: BorderRadius.circular(8.0),
//     //         borderSide: BorderSide(width: 1, color: Color(0xff2382AA)),
//     //       ),
//     //       isDense: true,
//     //       contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//     //       constraints: BoxConstraints.tight(const Size.fromHeight(AppSize.s10)),
//     //     ),
//     //     menuStyle: MenuStyle(
//     //       backgroundColor: WidgetStatePropertyAll<Color>(
//     //           Color.fromARGB(255, 255, 255, 255)),
//     //     )),
//   );
//
//   static final darkTheme2 = ThemeData(
//   //   canvasColor: Color(0xff1A3848),
//   //   primaryColor: const Color(0xff2382AA),
//   //   colorScheme: ColorScheme.dark(
//   //       background: Color(0xff0D1F29),
//   //       primary: Color(0xff98A2B3),
//   //       secondary: Colors.grey[800]!),
//   //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//   //     backgroundColor: Color(0xff2382AA),
//   //     selectedItemColor:
//   //         Color.fromARGB(255, 255, 255, 255), // Selected item color
//   //     unselectedItemColor: Colors.grey, // Unselected item color
//   //   ),
//   //   cardColor: Color(0xff1A3848),
//   //   textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
//   //   brightness: Brightness.dark,
//   //   appBarTheme: AppBarTheme(
//   //     systemOverlayStyle: SystemUiOverlayStyle.light,
//   //     elevation: 0,
//   //     surfaceTintColor: Color(0xff2382AA),
//   //     shadowColor: Color(0xff2382AA),
//   //     backgroundColor: Color(0xff0D1F29),
//   //   ),
//   //   inputDecorationTheme: InputDecorationTheme(
//   //     filled: true,
//   //     fillColor: Color(0xff1A3848),
//   //     enabledBorder: UnderlineInputBorder(
//   //       borderRadius: BorderRadius.circular(8.0),
//   //     ),
//   //     focusedBorder: UnderlineInputBorder(
//   //       borderRadius: BorderRadius.circular(8.0),
//   //     ),
//   //     constraints: BoxConstraints.expand(height: 48),
//   //   ),
//   //   dropdownMenuTheme: DropdownMenuThemeData(
//   //       inputDecorationTheme: InputDecorationTheme(
//   //         enabledBorder: OutlineInputBorder(
//   //           borderRadius: BorderRadius.circular(8.0),
//   //           borderSide: BorderSide(width: 2, color: Color(0xff2382AA)),
//   //         ),
//   //         isDense: true,
//   //         contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//   //         constraints: BoxConstraints.tight(const Size.fromHeight(40)),
//   //       ),
//   //       menuStyle: MenuStyle(
//   //         backgroundColor:
//   //             WidgetStatePropertyAll<Color>(Color.fromARGB(255, 26, 56, 72)),
//   //       )),
//   );
// }
