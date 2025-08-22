import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

//<------------------- CONSTANTS ------------------->
const Size kDesignSize = Size(390, 844);

//<------------------- COLORS ------------------->
class LightModeColors {
  static const lightPrimary = Color(0xFF1B365D); // Dark blue
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFF1B365D);
  static const lightOnPrimaryContainer = Color(0xFFFFFFFF);
  static const lightSecondary = Color(0xFF4A90E2); // Light blue
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightTertiary = Color(0xFF34C759); // Success green
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightError = Color(0xFFFF3B30);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFDAD6);
  static const lightOnErrorContainer = Color(0xFF410002);
  static const lightInversePrimary = Color(0xFF4A90E2);
  static const lightShadow = Color(0xFF000000);
  static const lightSurface = Color(0xFFFFFFFF); // Pure white
  static const lightBackground = Color(0xFFF6F6F6); // Standard UX background
  static const lightOnSurface = Color(0xFF2C2C2E);
  static const lightAppBarBackground = Color(0xFFFFFFFF); // Transparent white
}

class DarkModeColors {
  static const darkPrimary = Color(0xFF4A90E2);
  static const darkOnPrimary = Color(0xFFFFFFFF);
  static const darkPrimaryContainer = Color(0xFF1B365D);
  static const darkOnPrimaryContainer = Color(0xFF4A90E2);
  static const darkSecondary = Color(0xFF6BB6FF);
  static const darkOnSecondary = Color(0xFF003A6B);
  static const darkTertiary = Color(0xFF34C759);
  static const darkOnTertiary = Color(0xFF002818);
  static const darkError = Color(0xFFFF6961);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);
  static const darkInversePrimary = Color(0xFF1B365D);
  static const darkShadow = Color(0xFF000000);
  static const darkSurface = Color(0xFF1C1C1E);
  static const darkBackground = Color(0xFF000000);
  static const darkOnSurface = Color(0xFFE5E5E7);
  static const darkAppBarBackground = Color(0xFF1C1C1E);
}

//<------------------- SPACING ------------------->
class AppSpacing {
  static final double small = 8.w;
  static final double medium = 16.w;
  static final double large = 24.w;
  static final double extraLarge = 32.w;
  static final double extraBitLarge = 48.w;
  static final double superExtraLarge = 64.w;
  static final double smallH = 8.h;
  static final double mediumH = 16.h;
  static final double largeH = 24.h;
  static final double extraLargeH = 32.h;
  static final double extraBitLargeH = 48.h;
  static final double superExtraLargeH = 64.h;

  // Responsive height spacers (SizedBox)
  static SizedBox get smallHeightSpacer => SizedBox(height: smallH);
  static SizedBox get mediumHeightSpacer => SizedBox(height: mediumH);
  static SizedBox get largeHeightSpacer => SizedBox(height: largeH);
  static SizedBox get extraLargeHeightSpacer => SizedBox(height: extraLargeH);

  // Responsive width spacers (SizedBox)
  static SizedBox get smallWidthSpacer => SizedBox(width: small);
  static SizedBox get mediumWidthSpacer => SizedBox(width: medium);
  static SizedBox get largeWidthSpacer => SizedBox(width: large);
  static SizedBox get extraLargeWidthSpacer => SizedBox(width: extraLarge);

  // Responsive height spacer widgets (for direct use as Widgets)
  static Widget get smallHeightSpacerWidget => SizedBox(height: smallH);
  static Widget get mediumHeightSpacerWidget => SizedBox(height: mediumH);
  static Widget get largeHeightSpacerWidget => SizedBox(height: largeH);
  static Widget get extraLargeHeightSpacerWidget =>
      SizedBox(height: extraLargeH);

  // Responsive width spacer widgets (for direct use as Widgets)
  static Widget get smallWidthSpacerWidget => SizedBox(width: small);
  static Widget get mediumWidthSpacerWidget => SizedBox(width: medium);
  static Widget get largeWidthSpacerWidget => SizedBox(width: large);
  static Widget get extraLargeWidthSpacerWidget => SizedBox(width: extraLarge);
}

//<------------------- RADIUS ------------------->
class AppRadius {
  static final double small = 8.r;
  static final double medium = 16.r;
  static final double large = 24.r;
  static final double extraLarge = 32.r;
}

//<------------------- FONT SIZES ------------------->
class AppFontSize {
  static final double displayLarge = 57.sp;
  static final double displayMedium = 45.sp;
  static final double displaySmall = 36.sp;
  static final double headlineLarge = 32.sp;
  static final double headlineMedium = 24.sp;
  static final double headlineSmall = 22.sp;
  static final double titleLarge = 22.sp;
  static final double titleMedium = 18.sp;
  static final double titleSmall = 16.sp;
  static final double labelLarge = 16.sp;
  static final double labelMedium = 14.sp;
  static final double labelSmall = 12.sp;
  static final double bodyLarge = 16.sp;
  static final double bodyMedium = 14.sp;
  static final double bodySmall = 12.sp;
}

//<------------------- SHADOWS ------------------->
class AppShadows {
  static final BoxShadow small = BoxShadow(
    color: LightModeColors.lightShadow.withOpacity(0.1),
    blurRadius: 8.r,
    offset: Offset(0, 4.h),
  );
  static final BoxShadow medium = BoxShadow(
    color: LightModeColors.lightShadow.withOpacity(0.15),
    blurRadius: 16.r,
    offset: Offset(0, 8.h),
  );
  static final BoxShadow large = BoxShadow(
    color: LightModeColors.lightShadow.withOpacity(0.2),
    blurRadius: 24.r,
    offset: Offset(0, 12.h),
  );
}

//<------------------- PADDINGS ------------------->
class AppPaddings {
  static const cardContent = EdgeInsets.symmetric(vertical: 10, horizontal: 8);
  static final pageHome = EdgeInsets.only(
    top: 32.h,
    left: 20.w,
    right: 20.w,
    bottom: 20.h,
  );
}

//<------------------- SPACINGS ------------------->
class AppSpacings {
  static const medium = SizedBox(height: 12);
  static const small = SizedBox(height: 4);
  static const cardGap = SizedBox(width: 12);
}

//<------------------- ICON SIZES ------------------->
class AppIconSizes {
  static final small = 16.sp;
  static final medium = 24.sp;
  static final large = 32.sp;
  static final extraLarge = 48.sp;
  static final extraBitLarge = 64.sp;
  static final superExtraLarge = 96.sp;
}

//<------------------- ACTION COLORS ------------------->
class AppActionColors {
  static const create = Color(0xFF34C759); // Vibrant green
  static const join = Color(0xFF007AFF); // Bright blue
  static const myTontines = Color(0xFFAF52DE); // Friendly purple
  static const history = Color(0xFFFF9500); // Bold orange
  static const sunuPoints = Color(0xFFFF2D55); // Vivid pink/red
  static const reports = Color(0xFF5AC8FA); // Light blue
}

//<------------------- THEMES ------------------->
ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    primaryContainer: LightModeColors.lightPrimaryContainer,
    onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    error: LightModeColors.lightError,
    onError: LightModeColors.lightOnError,
    errorContainer: LightModeColors.lightErrorContainer,
    onErrorContainer: LightModeColors.lightOnErrorContainer,
    inversePrimary: LightModeColors.lightInversePrimary,
    shadow: LightModeColors.lightShadow,
    surface: LightModeColors.lightSurface,
    background: LightModeColors.lightBackground,
    onSurface: LightModeColors.lightOnSurface,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: LightModeColors.lightBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: LightModeColors.lightPrimary,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: LightModeColors.lightPrimary),
    titleTextStyle: TextStyle(
      color: LightModeColors.lightPrimary,
      fontWeight: FontWeight.bold,
      fontSize: AppFontSize.headlineSmall,
    ),
  ),
  cardTheme: CardThemeData(
    color: LightModeColors.lightSurface,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.large),
    ),
    margin: EdgeInsets.symmetric(
      vertical: AppSpacing.medium,
      horizontal: AppSpacing.small,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: AppFontSize.displayLarge,
      fontWeight: FontWeight.normal,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: AppFontSize.displayMedium,
      fontWeight: FontWeight.normal,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: AppFontSize.displaySmall,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: AppFontSize.headlineLarge,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: AppFontSize.headlineMedium,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: AppFontSize.headlineSmall,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: AppFontSize.titleLarge,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: AppFontSize.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: AppFontSize.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: AppFontSize.labelLarge,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: AppFontSize.labelMedium,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: AppFontSize.labelSmall,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: AppFontSize.bodyLarge,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: AppFontSize.bodyMedium,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: AppFontSize.bodySmall,
      fontWeight: FontWeight.normal,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(
      vertical: AppSpacing.medium,
      horizontal: AppSpacing.medium,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStatePropertyAll(
        EdgeInsets.symmetric(
          vertical: AppSpacing.medium,
          horizontal: AppSpacing.extraLarge,
        ),
      ),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
        ),
      ),
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          fontSize: AppFontSize.titleMedium,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: DarkModeColors.darkPrimary,
    onPrimary: DarkModeColors.darkOnPrimary,
    primaryContainer: DarkModeColors.darkPrimaryContainer,
    onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
    secondary: DarkModeColors.darkSecondary,
    onSecondary: DarkModeColors.darkOnSecondary,
    tertiary: DarkModeColors.darkTertiary,
    onTertiary: DarkModeColors.darkOnTertiary,
    error: DarkModeColors.darkError,
    onError: DarkModeColors.darkOnError,
    errorContainer: DarkModeColors.darkErrorContainer,
    onErrorContainer: DarkModeColors.darkOnErrorContainer,
    inversePrimary: DarkModeColors.darkInversePrimary,
    shadow: DarkModeColors.darkShadow,
    surface: DarkModeColors.darkSurface,
    background: DarkModeColors.darkBackground,
    onSurface: DarkModeColors.darkOnSurface,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: DarkModeColors.darkBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: DarkModeColors.darkPrimary,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      color: DarkModeColors.darkPrimary,
      fontWeight: FontWeight.bold,
      fontSize: AppFontSize.headlineSmall,
    ),
  ),
  cardTheme: CardThemeData(
    color: DarkModeColors.darkSurface,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: AppFontSize.displayLarge,
      fontWeight: FontWeight.normal,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: AppFontSize.displayMedium,
      fontWeight: FontWeight.normal,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: AppFontSize.displaySmall,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: AppFontSize.headlineLarge,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: AppFontSize.headlineMedium,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: AppFontSize.headlineSmall,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: AppFontSize.titleLarge,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: AppFontSize.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: AppFontSize.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: AppFontSize.labelLarge,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: AppFontSize.labelMedium,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: AppFontSize.labelSmall,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: AppFontSize.bodyLarge,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: AppFontSize.bodyMedium,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: AppFontSize.bodySmall,
      fontWeight: FontWeight.normal,
    ),
  ),
);
