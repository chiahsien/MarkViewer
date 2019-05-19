//
//  MarkdownView.swift
//  Mark Viewer
//
//  Created by Nelson Dai on 2019/5/9.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import WebKit
import EFMarkdown

final class MarkdownView: WKWebView {
    private let bundle: Bundle
    private lazy var baseURL: URL = {
        return self.bundle.url(forResource: "index", withExtension: "html")!
    }()
    private var markdownToHTMLString: String?
    var openURLHandler: ((URL) -> Void)?

    init(frame: CGRect) {
        let url = Bundle.main.url(forResource: "Default", withExtension: "bundle")!
        bundle = Bundle(url: url)!

        super.init(frame: frame, configuration: WKWebViewConfiguration())
        navigationDelegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(markdownString: String) {
        markdownToHTMLString = try? EFMarkdown().markdownToHTML(markdownString, options: [.default, .smart, .githubPreLang])
        try? loadHTMLView(markdownToHTMLString)
    }
}

// MARK: - Private API
private extension MarkdownView {
    func loadHTMLView(_ htmlString: String?) throws {
        guard let htmlString = htmlString else { return }
        let pageHTMLString = try htmlFromTemplate(htmlString)

        loadHTMLString(pageHTMLString, baseURL: baseURL)
    }

    func htmlFromTemplate(_ htmlString: String) throws -> String {
        let template = try String(contentsOf: baseURL, encoding: .utf8)
        return template.replacingOccurrences(of: "${PLACEHOLDER}$", with: htmlString)
    }
}

// MARK: - WKNavigationDelegate
extension MarkdownView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return decisionHandler(.allow) }

        switch navigationAction.navigationType {
        case .linkActivated:
            if let scheme = url.scheme, configuration.urlSchemeHandler(forURLScheme: scheme) != nil {
                decisionHandler(.allow)
                return
            }
            decisionHandler(.cancel)
            openURL(url: url)
        default:
            decisionHandler(.allow)
        }
    }

    @available(iOSApplicationExtension, unavailable)
    func openURL(url: URL) {
        openURLHandler?(url)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// Do nothing.
    }
}

private extension WKNavigationDelegate {
    /// A wrapper for `UIApplication.shared.openURL` so that an empty default
    /// implementation is available in app extensions
    func openURL(url: URL) {}
}
