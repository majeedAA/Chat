// import 'package:firebase_remote_config/firebase_remote_config.dart';

// const String _ShowMainBanner = "show_main_banner";

// class RemoteConfigService {

//   final defaults = <String, dynamic>{_ShowMainBanner: false};

//   bool get showMainBanner => _remoteConfig.getBool(_ShowMainBanner);
//   final RemoteConfig _remoteConfig;

//     RemoteConfigService({RemoteConfig remoteConfig})
//       : _remoteConfig = remoteConfig;

//   static RemoteConfigService _instance;
//   static Future<RemoteConfigService> getInstance() async {
//     if (_instance == null) {
//       _instance = RemoteConfigService(
//         remoteConfig: await RemoteConfig.instance,
//       );
//     }

//     return _instance;
//   }

//   Future initialise() async {
//     try {
//       await _remoteConfig.setDefaults(defaults);
//       await _fetchAndActivate();
//     } on FetchThrottledException catch (exception) {
//       // Fetch throttled.
//       print('Remote config fetch throttled: $exception');
//     } catch (exception) {
//       print('Unable to fetch remote config. Cached or default values will be '
//           'used');
//     }
//   }

//     Future _fetchAndActivate() async {
//     await _remoteConfig.fetch();
//     await _remoteConfig.activateFetched();
//   }

// }
