import SwiftUI

struct URLSessionView: View {
    var url: URL
    @Binding var useCertificate: Bool

    @State var result: String = ""

    var body: some View {
        Text(result)
            .task {
                self.result = await sendHTTPRequest(url, useCertificate: useCertificate)
            }
    }

    func sendHTTPRequest(_ url: URL, useCertificate: Bool) async -> String {
        let session = URLSession(configuration: .default, delegate: useCertificate ? URLSesionClientCertificateHandling() : nil, delegateQueue: nil)
        do {
            let (_, response) = try await session.data(from: url, delegate: nil)
            guard let httpResponse = response as? HTTPURLResponse else { return "" }
            return "HTTP Status Code \(httpResponse.statusCode)"
        } catch {
            return error.localizedDescription
        }
    }
}

public class URLSesionClientCertificateHandling: NSObject, URLSessionDelegate {
    public func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod
            == NSURLAuthenticationMethodClientCertificate
        else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        guard let credential = ClientCertificateSwiftDemoApp.urlCredential(for: Bundle.main.userCertificateForBadSSLWebsite) else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        challenge.sender?.use(credential, for: challenge)
        completionHandler(.useCredential, credential)
    }
}
