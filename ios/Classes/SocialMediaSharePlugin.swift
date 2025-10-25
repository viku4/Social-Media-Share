import Flutter
import UIKit

public class SocialMediaSharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "social_media_share/channel", binaryMessenger: registrar.messenger())
    let instance = SocialMediaSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "share_whatsapp":
        let args = call.arguments as? [String: Any]
        let text = args?["text"] as? String
        let filePath = args?["filePath"] as? String
        shareToWhatsApp(text: text, filePath: filePath)
        result(nil)
    default:
        result(FlutterMethodNotImplemented)
    }
  }

  private func shareToWhatsApp(text: String?, filePath: String?) {
    guard let text = text else { return }

    if let whatsappURL = URL(string: "whatsapp://send?text=\(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
       UIApplication.shared.canOpenURL(whatsappURL) {

      if let filePath = filePath, FileManager.default.fileExists(atPath: filePath) {
          // Image + text → fallback to share sheet
          var items: [Any] = [text, URL(fileURLWithPath: filePath)]
          let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
          UIApplication.shared.windows.first?.rootViewController?.present(ac, animated: true, completion: nil)
      } else {
          // Text only → open WhatsApp directly
          UIApplication.shared.open(whatsappURL)
      }
    } else {
      print("WhatsApp not installed on iOS")
    }
  }
}
