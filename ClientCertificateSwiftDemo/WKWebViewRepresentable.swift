import SwiftUI
import WebKit

struct WKWebViewRepresentable: UIViewRepresentable {
    var url: URL
    var useCertificate: Bool

    func makeCoordinator() -> BadSSLCoordinator {
        Coordinator(self, useCertificate: useCertificate)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_: WKWebView, context _: Context) {}
}

class BadSSLCoordinator: NSObject {
    var parent: WKWebViewRepresentable
    var useCertificate: Bool

    init(_ parent: WKWebViewRepresentable, useCertificate: Bool) {
        self.parent = parent
        self.useCertificate = useCertificate
    }
}

extension BadSSLCoordinator: WKNavigationDelegate {
    func webView(_: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard useCertificate else {
            completionHandler(.performDefaultHandling, .none)
            return
        }

        let method = challenge.protectionSpace.authenticationMethod

        switch method {
        case NSURLAuthenticationMethodClientCertificate:

            guard let credential = ClientCertificateSwiftDemoApp.urlCredential(for: Bundle.main.userCertificateForBadSSLWebsite) else {
                challenge.sender?.cancel(challenge)
                return completionHandler(.rejectProtectionSpace, .none)
            }

            return completionHandler(.useCredential, credential)

        default:
            completionHandler(.performDefaultHandling, .none)
        }
    }
}
