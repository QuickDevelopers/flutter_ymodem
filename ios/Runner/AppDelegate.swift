import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      // if use methodchannel
      YModemChannel(messenger: controller.binaryMessenger)
      GeneratedPluginRegistrant.register(with: self)
      
      // if use  pigeon
      //let api = YModemAPi()
      //YmodemRequestApiSetup.setUp(getFlutterEngine().binaryMessenger, api)
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
