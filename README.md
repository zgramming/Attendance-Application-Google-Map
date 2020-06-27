<p align="center">
  <img src="http://www.zimprov.id/absensi_online/readme/absensi_online/banner_github.png"  height="300" width="600" style="">
</p>

# Attendance Application [Google Maps Version]

Attendance Tracking Application , implementation using Flutter Google Map and Geolocator packages for tracking user location. Backend used is Codeigniter 3.

## Configuration Project 

### Android 
Open `Android/app/src/main/AndroidManifest.xml` and replace the API key with yours.

```
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```
### IOS

Specify your API key in the application delegate `ios/Runner/AppDelegate.m`:

```
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```
Or in your swift code, specify your API key in the application delegate `ios/Runner/AppDelegate.swift`:

```
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Installing

1. Git clone **https://github.com/zgramming/Attendance-Application-Google-Map**
2. cd `Attendance-Application-Google-Map`
3. in terminal `flutter packages get`. After that `flutter run`

## Overview

|Splash Screen|Home Screen|Profil Screen|Maps Screen|
|:-----------:|:--------:|:------------:|:---------:|
|<img src="http://www.zimprov.id/absensi_online/readme/absensi_online/splash_screen(1).gif" height="400" width="200">|<img src="http://www.zimprov.id/absensi_online/readme/absensi_online/welcome_screen(1).gif" height="400" width="200">|<img src="http://www.zimprov.id/absensi_online/readme/absensi_online/profil_screen(1).gif" height="400" width="200">|<img src="http://www.zimprov.id/absensi_online/readme/absensi_online/maps_screen(1).gif" height="400" width="200">|

|Add Destination|Pick Destination|Login Screen|
|:-------------:|:--------------:|:----------:|
|<img src="http://www.zimprov.id/absensi_online/readme/absensi_online/add_destination(1).gif" height="400" width="200">|<img src="http://www.zimprov.id/absensi_online/readme/absensi_online/pick_destination(1).gif" height="400" width="200">|<img src="http://www.zimprov.id/absensi_online/readme/absensi_online/login_screen(1).gif" height="400" width="200">|


## Feature

- [x] Tracking user location
- [x] Autocomplete From Geolocator Package
- [x] Absent only at certain radius [radius color will be green if user inside radius otherwise radius color will be purple]
- [x] Detecting mockup location
- [x] Add destination based on user choose in maps
- [x] Pick Destination [this will be used as your absence location]
- [x] Recap user absence monthly, has 2 view [Card & Table look]
- [x] Recap user performance monthly
- [x] User Profil
- [x] Drawer Menu
- [ ] Unimaginable Improvements 

## Download

|app-arm64-v8a|app-armeabi-v7a|app-x86_64|
|:-----------:|:-------------:|:--------:|
|[<img src="https://upload.wikimedia.org/wikipedia/commons/a/a0/APK_format_icon.png" width="50px">](http://www.zimprov.id/absensi_online/apk/absensi_online/app-arm64-v8a-release.apk)|[<img src="https://upload.wikimedia.org/wikipedia/commons/a/a0/APK_format_icon.png" width="50px">](http://www.zimprov.id/absensi_online/apk/absensi_online/app-armeabi-v7a-release.apk)|[<img src="https://upload.wikimedia.org/wikipedia/commons/a/a0/APK_format_icon.png" width="50px">](http://www.zimprov.id/absensi_online/apk/absensi_online/app-x86_64-release.apk)|
|7,8 MB|7,4 MB|8 MB|

## API

If you interested with the API in this application and want custom the API with yours , you can follow this <a href="https://github.com/zgramming/API.Absensi-Online"><b>Link<b/></a>

## Issues

Please file any issues, bugs or feature request as an issue on <a href="https://github.com/zgramming/Attendance-Application-Google-Map/issues"><b> Github </b></a>

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
