import Flutter
import UIKit
import GoogleMaps
import Foundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let env = ProcessInfo.processInfo.environment
    GMServices.provideAPIKey(env["MAPS_IOS"])
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
