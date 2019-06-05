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
    enum SyntaxHighlight: String, CaseIterable {
        case google = "Google Code"
        case oneDark = "Atom One Dark"
        case darcula = "Darcula"
        case github = "Github"
    }

    private let bundle: Bundle
    private lazy var baseURL: URL = {
        return self.bundle.url(forResource: "index", withExtension: "html")!
    }()
    private var markdownToHTMLString: String?
    private lazy var syntaxHighlight: SyntaxHighlight = {
        if let style = UserDefaults.standard.string(forKey: SettingKey.syntaxHighlight) {
            return SyntaxHighlight(rawValue: style)!
        } else {
            return SyntaxHighlight.github
        }
    }()

    var openURLHandler: ((URL) -> Void)?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(frame: CGRect) {
        let url = Bundle.main.url(forResource: "MarkdownView", withExtension: "bundle")!
        bundle = Bundle(url: url)!

        super.init(frame: frame, configuration: WKWebViewConfiguration())
        navigationDelegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(syntaxHighlightSettingDidChange(_:)), name: .MarkdownViewSyntaxHighlightSettingDidChange, object: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(markdownString: String) {
        markdownToHTMLString = try? EFMarkdown().markdownToHTML(markdownString, options: [.default, .smart, .githubPreLang])
        try? loadHTMLView(markdownToHTMLString, syntaxHighlight: syntaxHighlight)
    }

    func change(syntaxHighlight: SyntaxHighlight) {
        if self.syntaxHighlight == syntaxHighlight { return }
        self.syntaxHighlight = syntaxHighlight
        let js = "changeCSS('\(syntaxHighlight.rawValue)')"
        evaluateJavaScript(js, completionHandler: nil)
    }

    func loadCodeSample() {
        let sampleURL = bundle.url(forResource: "code", withExtension: "md")!
        let markdown = try? String(contentsOf: sampleURL, encoding: .utf8)
        update(markdownString: markdown ?? "")
    }
}

// MARK: - Private API
private extension MarkdownView {
    func loadHTMLView(_ htmlString: String?, syntaxHighlight: SyntaxHighlight) throws {
        guard let htmlString = htmlString else { return }
        let pageHTMLString = try htmlFromTemplate(htmlString, syntaxHighlight: syntaxHighlight)

        loadHTMLString(pageHTMLString, baseURL: baseURL)
    }

    func htmlFromTemplate(_ htmlString: String, syntaxHighlight: SyntaxHighlight) throws -> String {
        var template = try String(contentsOf: baseURL, encoding: .utf8)
        template = template.replacingOccurrences(of: "${SYNTAX_HIGHLIGHT}$", with: syntaxHighlight.rawValue)
        template = template.replacingOccurrences(of: "${BODY}$", with: htmlString)
        return template
    }

    @objc func syntaxHighlightSettingDidChange(_ note: NSNotification) {
        if let style = note.userInfo?[SettingKey.syntaxHighlight], let highlight = SyntaxHighlight(rawValue: style as! String) {
            change(syntaxHighlight: highlight)
        }
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
}

private extension WKNavigationDelegate {
    /// A wrapper for `UIApplication.shared.openURL` so that an empty default
    /// implementation is available in app extensions
    func openURL(url: URL) {}
}
