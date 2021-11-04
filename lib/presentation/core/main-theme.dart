import 'package:flutter/material.dart';

class AppThemeData {
    AndroidOverscrollIndicator? androidOverscrollIndicator;
    bool? applyElevationOverlayColor;
    InputDecorationTheme? inputDecorationTheme;
    MaterialTapTargetSize? materialTapTargetSize;
    PageTransitionsTheme? pageTransitionsTheme;
    TargetPlatform? platform;
    ScrollbarThemeData? scrollbarTheme;
    InteractiveInkFeatureFactory? splashFactory;
    VisualDensity? visualDensity;
    ColorScheme? colorScheme;
    Brightness? brightness;
    Color? primaryColor;
    Brightness? primaryColorBrightness;
    Color? primaryColorLight;
    Color? primaryColorDark;
    Color? focusColor;
    Color? hoverColor;
    Color? shadowColor;
    Color? canvasColor;
    Color? scaffoldBackgroundColor;
    Color? bottomAppBarColor;
    Color? cardColor;
    Color? dividerColor;
    Color? highlightColor;
    Color? splashColor;
    Color? selectedRowColor;
    Color? unselectedWidgetColor;
    Color? disabledColor;
    Color? secondaryHeaderColor;
    Color? backgroundColor;
    Color? dialogBackgroundColor;
    Color? indicatorColor;
    Color? hintColor;
    Color? errorColor;
    Color? toggleableActiveColor;
    // TYPOGRAPHY & ICONOGRAPHY
    Typography? typography;
    TextTheme? textTheme;
    TextTheme? primaryTextTheme;
    IconThemeData? iconTheme;
    IconThemeData? primaryIconTheme;
    // COMPONENT THEMES
    AppBarTheme? appBarTheme;
    MaterialBannerThemeData? bannerTheme;
    BottomAppBarTheme? bottomAppBarTheme;
    BottomNavigationBarThemeData? bottomNavigationBarTheme;
    BottomSheetThemeData? bottomSheetTheme;
    ButtonBarThemeData? buttonBarTheme;
    ButtonThemeData? buttonTheme;
    CardTheme? cardTheme;
    CheckboxThemeData? checkboxTheme;
    ChipThemeData? chipTheme;
    DataTableThemeData? dataTableTheme;
    DialogTheme? dialogTheme;
    DividerThemeData? dividerTheme;
    DrawerThemeData? drawerTheme;
    ElevatedButtonThemeData? elevatedButtonTheme;
    FloatingActionButtonThemeData? floatingActionButtonTheme;
    ListTileThemeData? listTileTheme;
    NavigationBarThemeData? navigationBarTheme;
    NavigationRailThemeData? navigationRailTheme;
    OutlinedButtonThemeData? outlinedButtonTheme;
    PopupMenuThemeData? popupMenuTheme;
    ProgressIndicatorThemeData? progressIndicatorTheme;
    RadioThemeData? radioTheme;
    SliderThemeData? sliderTheme;
    SnackBarThemeData? snackBarTheme;
    SwitchThemeData? switchTheme;
    TabBarTheme? tabBarTheme;
    TextButtonThemeData? textButtonTheme;
    TextSelectionThemeData? textSelectionTheme;
    TimePickerThemeData? timePickerTheme;
    ToggleButtonsThemeData? toggleButtonsTheme;
    TooltipThemeData? tooltipTheme;

  AppThemeData({    
    this.androidOverscrollIndicator,
    this.applyElevationOverlayColor,
    this.inputDecorationTheme,
    this.materialTapTargetSize,
    this.pageTransitionsTheme,
    this.platform,
    this.scrollbarTheme,
    this.splashFactory,
    this.visualDensity,
    this.colorScheme,
    this.brightness,
    this.primaryColor,
    this.primaryColorBrightness,
    this.primaryColorLight,
    this.primaryColorDark,
    this.focusColor,
    this.hoverColor,
    this.shadowColor,
    this.canvasColor,
    this.scaffoldBackgroundColor,
    this.bottomAppBarColor,
    this.cardColor,
    this.dividerColor,
    this.highlightColor,
    this.splashColor,
    this.selectedRowColor,
    this.unselectedWidgetColor,
    this.disabledColor,
    this.secondaryHeaderColor,
    this.backgroundColor,
    this.dialogBackgroundColor,
    this.indicatorColor,
    this.hintColor,
    this.errorColor,
    this.toggleableActiveColor,
    // TYPOGRAPHY & ICONOGRAPHY
    this.typography,
    this.textTheme,
    this.primaryTextTheme,
    this.iconTheme,
    this.primaryIconTheme,
    // COMPONENT THEMES
    this.appBarTheme,
    this.bannerTheme,
    this.bottomAppBarTheme,
    this.bottomNavigationBarTheme,
    this.bottomSheetTheme,
    this.buttonBarTheme,
    this.buttonTheme,
    this.cardTheme,
    this.checkboxTheme,
    this.chipTheme,
    this.dataTableTheme,
    this.dialogTheme,
    this.dividerTheme,
    this.drawerTheme,
    this.elevatedButtonTheme,
    this.floatingActionButtonTheme,
    this.listTileTheme,
    this.navigationBarTheme,
    this.navigationRailTheme,
    this.outlinedButtonTheme,
    this.popupMenuTheme,
    this.progressIndicatorTheme,
    this.radioTheme,
    this.sliderTheme,
    this.snackBarTheme,
    this.switchTheme,
    this.tabBarTheme,
    this.textButtonTheme,
    this.textSelectionTheme,
    this.timePickerTheme,
    this.toggleButtonsTheme,
    this.tooltipTheme,
  });
  ThemeData def() {
    return ThemeData(    
      androidOverscrollIndicator: androidOverscrollIndicator ?? ThemeData().androidOverscrollIndicator,
      applyElevationOverlayColor: applyElevationOverlayColor ?? ThemeData().applyElevationOverlayColor,
      inputDecorationTheme: inputDecorationTheme ?? ThemeData().inputDecorationTheme,
      materialTapTargetSize: materialTapTargetSize ?? ThemeData().materialTapTargetSize,
      pageTransitionsTheme: pageTransitionsTheme ?? ThemeData().pageTransitionsTheme,
      platform: platform ?? ThemeData().platform,
      scrollbarTheme: scrollbarTheme ?? ThemeData().scrollbarTheme,
      splashFactory: splashFactory ?? ThemeData().splashFactory,
      visualDensity: visualDensity ?? ThemeData().visualDensity,
      colorScheme: colorScheme ?? ThemeData().colorScheme,
      brightness: brightness ?? ThemeData().brightness,
      primaryColor: primaryColor ?? ThemeData().primaryColor,
      primaryColorBrightness: primaryColorBrightness ?? ThemeData().primaryColorBrightness,
      primaryColorLight: primaryColorLight ?? ThemeData().primaryColorLight,
      primaryColorDark: primaryColorDark ?? ThemeData().primaryColorDark,
      focusColor: focusColor ?? ThemeData().focusColor,
      hoverColor: hoverColor ?? ThemeData().hoverColor,
      shadowColor: shadowColor ?? ThemeData().shadowColor,
      canvasColor: canvasColor ?? ThemeData().canvasColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? ThemeData().scaffoldBackgroundColor,
      bottomAppBarColor: bottomAppBarColor ?? ThemeData().bottomAppBarColor,
      cardColor: cardColor ?? ThemeData().cardColor,
      dividerColor: dividerColor ?? ThemeData().dividerColor,
      highlightColor: highlightColor ?? ThemeData().highlightColor,
      splashColor: splashColor ?? ThemeData().splashColor,
      selectedRowColor: selectedRowColor ?? ThemeData().selectedRowColor,
      unselectedWidgetColor: unselectedWidgetColor ?? ThemeData().unselectedWidgetColor,
      disabledColor: disabledColor ?? ThemeData().disabledColor,
      secondaryHeaderColor: secondaryHeaderColor ?? ThemeData().secondaryHeaderColor,
      backgroundColor: backgroundColor ?? ThemeData().backgroundColor,
      dialogBackgroundColor: dialogBackgroundColor ?? ThemeData().dialogBackgroundColor,
      indicatorColor: indicatorColor ?? ThemeData().indicatorColor,
      hintColor: hintColor ?? ThemeData().hintColor,
      errorColor: errorColor ?? ThemeData().errorColor,
      toggleableActiveColor: toggleableActiveColor ?? ThemeData().toggleableActiveColor,
      // TYPOGRAPHY & ICONOGRAPHY
      typography: typography ?? ThemeData().typography,
      textTheme: textTheme ?? ThemeData().textTheme,
      primaryTextTheme: primaryTextTheme ?? ThemeData().primaryTextTheme,
      iconTheme: iconTheme ?? ThemeData().iconTheme,
      primaryIconTheme: primaryIconTheme ?? ThemeData().primaryIconTheme,
      // COMPONENT THEMES
      appBarTheme: appBarTheme ?? ThemeData().appBarTheme,
      bannerTheme: bannerTheme ?? ThemeData().bannerTheme,
      bottomAppBarTheme: bottomAppBarTheme ?? ThemeData().bottomAppBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme ?? ThemeData().bottomNavigationBarTheme,
      bottomSheetTheme: bottomSheetTheme ?? ThemeData().bottomSheetTheme,
      buttonBarTheme: buttonBarTheme ?? ThemeData().buttonBarTheme,
      buttonTheme: buttonTheme ?? ThemeData().buttonTheme,
      cardTheme: cardTheme ?? ThemeData().cardTheme,
      checkboxTheme: checkboxTheme ?? ThemeData().checkboxTheme,
      chipTheme: chipTheme ?? ThemeData().chipTheme,
      dataTableTheme: dataTableTheme ?? ThemeData().dataTableTheme,
      dialogTheme: dialogTheme ?? ThemeData().dialogTheme,
      dividerTheme: dividerTheme ?? ThemeData().dividerTheme,
      drawerTheme: drawerTheme ?? ThemeData().drawerTheme,
      elevatedButtonTheme: elevatedButtonTheme ?? ThemeData().elevatedButtonTheme,
      floatingActionButtonTheme: floatingActionButtonTheme ?? ThemeData().floatingActionButtonTheme,
      listTileTheme: listTileTheme ?? ThemeData().listTileTheme,
      navigationBarTheme: navigationBarTheme ?? ThemeData().navigationBarTheme,
      navigationRailTheme: navigationRailTheme ?? ThemeData().navigationRailTheme,
      outlinedButtonTheme: outlinedButtonTheme ?? ThemeData().outlinedButtonTheme,
      popupMenuTheme: popupMenuTheme ?? ThemeData().popupMenuTheme,
      progressIndicatorTheme: progressIndicatorTheme ?? ThemeData().progressIndicatorTheme,
      radioTheme: radioTheme ?? ThemeData().radioTheme,
      sliderTheme: sliderTheme ?? ThemeData().sliderTheme,
      snackBarTheme: snackBarTheme ?? ThemeData().snackBarTheme,
      switchTheme: switchTheme ?? ThemeData().switchTheme,
      tabBarTheme: tabBarTheme ?? ThemeData().tabBarTheme,
      textButtonTheme: textButtonTheme ?? ThemeData().textButtonTheme,
      textSelectionTheme: textSelectionTheme ?? ThemeData().textSelectionTheme,
      timePickerTheme: timePickerTheme ?? ThemeData().timePickerTheme,
      toggleButtonsTheme: toggleButtonsTheme ?? ThemeData().toggleButtonsTheme,
      tooltipTheme: tooltipTheme ?? ThemeData().tooltipTheme,
    );
  }
}