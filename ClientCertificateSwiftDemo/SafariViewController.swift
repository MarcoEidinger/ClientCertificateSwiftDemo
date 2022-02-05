import SafariServices
import SwiftUI

struct SFSafariViewRepresentable: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context _: UIViewControllerRepresentableContext<SFSafariViewRepresentable>) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_: SFSafariViewController, context _: UIViewControllerRepresentableContext<SFSafariViewRepresentable>) {}
}
