import 'dart:io';

enum PlatformType { UNKNOWN, MOBILE, DESKTOP, WEB }

PlatformType getPlatformType() {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      return PlatformType.MOBILE;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return PlatformType.DESKTOP;
    }
  } catch (e) {
    if (e.toString().contains("Unsupported operation")) {
      return PlatformType.WEB;
    }
  }
  return PlatformType.UNKNOWN;
}
