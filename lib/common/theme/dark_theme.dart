import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_me/common/utils/coloors.dart';

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark();
  var copyWith = base.copyWith(
    backgroundColor: Coloors.backgroundDark,
    extensions: {
      CustomThemeExtension.darkMode,
    },
    // scaffoldBackgroundColor: Coloors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Coloors.greyBackgroundColor,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Coloors.greyDark,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(
        color: Coloors.greyDark,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Coloors.greenDark,
          width: 3,
        ),
      ),
      unselectedLabelColor: Coloors.greyDark,
      labelColor: Coloors.greenDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Coloors.greenDark,
        foregroundColor: Coloors.backgroundDark,
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Coloors.greyBackgroundColor,
        modalBackgroundColor: Coloors.greyBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        )),
    dialogBackgroundColor: Coloors.greyBackgroundColor,
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Coloors.greenDark,
      foregroundColor: Colors.white,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Coloors.greyDark,
      tileColor: Coloors.backgroundDark,
    ),
    switchTheme: const SwitchThemeData(
      thumbColor: MaterialStatePropertyAll(Coloors.greyDark),
      trackColor: MaterialStatePropertyAll(Color(0xFF344047)),
    ),
  );
  return copyWith;
}
