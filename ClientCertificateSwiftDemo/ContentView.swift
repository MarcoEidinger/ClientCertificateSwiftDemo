import SwiftUI

enum URLLoadingOption: String, CaseIterable {
    case urlSesson = "URLSession"
    case wkwebview = "WKWebView"
    case sfvc = "SFSafariViewController"
    case safari = "Safari"
}

struct ContentView: View {
    var urLoadingOptions = URLLoadingOption.allCases
    var url = URL(string: "https://client.badssl.com/")!

    @State var selectedLoadingOption = 0
    @State var selectedNavLink: Int? = nil
    @State var showSFSafariViewController = false

    @State var useCertificate = false

    @Environment(\.openURL) var openURL

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: URLSessionView(url: url, useCertificate: $useCertificate), tag: 1, selection: $selectedNavLink) { EmptyView() }
                NavigationLink(destination: WKWebViewRepresentable(url: url, useCertificate: useCertificate), tag: 2, selection: $selectedNavLink) { EmptyView() }

                Form {
                    Section("Using") {
                        Text("https://client.badssl.com/")
                    }

                    Section("Options") {
                        Picker("Load with", selection: $selectedLoadingOption) {
                            ForEach(0 ..< urLoadingOptions.count) { index in
                                Text(self.urLoadingOptions[index].rawValue)
                                    .tag(index)
                            }
                        }
                        Toggle("Use Certificate", isOn: $useCertificate)
                    }

                    Section {
                        Button(action: {
                            let selectedOption = urLoadingOptions[selectedLoadingOption]
                            switch selectedOption {
                            case .urlSesson:
                                selectedNavLink = 1
                            case .wkwebview:
                                selectedNavLink = 2
                            case .sfvc:
                                self.showSFSafariViewController = true
                            case .safari:
                                openURL(url)
                            }
                        }) {
                            Text("Go")
                        }
                    }
                    .sheet(isPresented: $showSFSafariViewController) {
                        SFSafariViewRepresentable(url: url)
                    }
                }
                .navigationBarTitle("Testing Client-Certifiate Authentication", displayMode: .inline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
