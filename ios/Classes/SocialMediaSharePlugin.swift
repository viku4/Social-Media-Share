import Flutter
import UIKit

public class SocialMediaSharePlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "social_media_share/channel", binaryMessenger: registrar.messenger())
        let instance = SocialMediaSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any?] else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Arguments missing", details: nil))
            return
        }

        let text = args["text"] as? String
        let filePath = args["filePath"] as? String

        switch call.method {
        case "share_whatsapp":
            shareToWhatsApp(text: text, filePath: filePath, result: result)
        case "share_facebook":
            shareToFacebook(text: text, filePath: filePath, result: result)
        case "share_instagram":
            shareToInstagram(text: text, filePath: filePath, result: result)
        case "share_all":
            shareToAll(text: text, filePath: filePath, result: result)
        case "copy_link":
            copyLink(text: text, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - WhatsApp
    private func shareToWhatsApp(text: String?, filePath: String?, result: @escaping FlutterResult) {
        if let url = URL(string: "whatsapp://send?text=\(text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            openStore("https://apps.apple.com/app/whatsapp-messenger/id310633997")
        }
        result(nil)
    }

    // MARK: - Facebook
    private func shareToFacebook(text: String?, filePath: String?, result: @escaping FlutterResult) {
        if let url = URL(string: "fb://"),
           UIApplication.shared.canOpenURL(url) {
            let items: [Any] = [text ?? ""]
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(activityVC)
        } else {
            openStore("https://apps.apple.com/app/facebook/id284882215")
        }
        result(nil)
    }

    // MARK: - Instagram
    private func shareToInstagram(text: String?, filePath: String?, result: @escaping FlutterResult) {
        guard let urlScheme = URL(string: "instagram://app") else {
            result(FlutterError(code: "INVALID_URL", message: "Invalid URL scheme", details: nil))
            return
        }

        if UIApplication.shared.canOpenURL(urlScheme) {
            var items: [Any] = []
            if let filePath = filePath {
                let fileURL = URL(fileURLWithPath: filePath)
                items.append(fileURL)
            }
            if let text = text { items.append(text) }

            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(activityVC)
        } else {
            openStore("https://apps.apple.com/app/instagram/id389801252")
        }
        result(nil)
    }

    // MARK: - All Share
    private func shareToAll(text: String?, filePath: String?, result: @escaping FlutterResult) {
        var items: [Any] = []
        if let text = text { items.append(text) }
        if let filePath = filePath {
            let fileURL = URL(fileURLWithPath: filePath)
            items.append(fileURL)
        }

        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityVC)
        result(nil)
    }

    // MARK: - Copy Link
    private func copyLink(text: String?, result: @escaping FlutterResult) {
        if let text = text {
            UIPasteboard.general.string = text
            showToast("Caption copied! Paste it in Instagram before posting.")
        }
        result(nil)
    }

    // MARK: - Helpers
    private func openStore(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    private func present(_ controller: UIViewController) {
        if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
            rootVC.present(controller, animated: true, completion: nil)
        }
    }

    private func showToast(_ message: String) {
        guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController else { return }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        rootVC.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}
