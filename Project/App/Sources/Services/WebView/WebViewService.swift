//
//  WebViewService.swift
//  Flifin
//
//  Created by 최혜린 on 1/11/26.
//

import Foundation
import WebKit

import ComposableArchitecture

@DependencyClient
struct WebViewService {
  var loadURL: @Sendable (_ url: URL) async -> Void
  var setupMessageHandler: @Sendable (_ handler: @escaping (WebViewMessage) -> Void) async -> Void
  var evaluateJavaScript: @Sendable (_ script: String) async throws -> Any?
  var getConfiguration: @Sendable () -> WKWebViewConfiguration = { WKWebViewConfiguration() }
}

extension WebViewService: TestDependencyKey {
  static let previewValue = Self()
  
  static let testValue = Self()
}

extension DependencyValues {
  var webViewService: WebViewService {
    get { self[WebViewService.self] }
    set { self[WebViewService.self] = newValue }
  }
}

extension WebViewService: DependencyKey {
  static let liveValue = WebViewService(
    loadURL: { url in
      WebViewCoordinator.shared.loadURL(url)
    },
    setupMessageHandler: { handler in
      WebViewCoordinator.shared.setupMessageHandler(handler)
    },
    evaluateJavaScript: { script in
      try await WebViewCoordinator.shared.evaluateJavaScript(script)
    },
    getConfiguration: {
      WebViewCoordinator.shared.getConfiguration()
    }
  )
}

@MainActor
final class WebViewCoordinator: NSObject {
  static let shared = WebViewCoordinator()
  
  private var webView: WKWebView?
  private var messageHandler: ((WebViewMessage) -> Void)?
  private let configuration: WKWebViewConfiguration
  
  private override init() {
    self.configuration = WKWebViewConfiguration()
    super.init()
    setupConfiguration()
  }
  
  private func setupConfiguration() {
    let userContentController = WKUserContentController()
    
    // iOS 방식 MessageHandler 등록
    userContentController.add(MessageHandler { [weak self] message in
      Task { @MainActor in
        self?.handleMessage(message)
      }
    }, name: "DHCJavascriptInterface")
 
    configuration.userContentController = userContentController
    configuration.applicationNameForUserAgent = "DHCApp"
  }
  
  nonisolated func getConfiguration() -> WKWebViewConfiguration {
    return configuration
  }
  
  func setWebView(_ webView: WKWebView) {
    self.webView = webView
  }
  
  func loadURL(_ url: URL) {
    let request = URLRequest(url: url)
    webView?.load(request)
  }
  
  func setupMessageHandler(_ handler: @escaping (WebViewMessage) -> Void) {
    self.messageHandler = handler
  }
  
  func evaluateJavaScript(_ script: String) async throws -> Any? {
    guard let webView = webView else {
      throw WebViewError.webViewNotInitialized
    }
    return try await webView.evaluateJavaScript(script)
  }
  
  private func handleMessage(_ message: WebViewMessage) {
    messageHandler?(message)
  }
}

private class MessageHandler: NSObject, WKScriptMessageHandler {
  private let handler: (WebViewMessage) -> Void
  
  init(handler: @escaping (WebViewMessage) -> Void) {
    self.handler = handler
    super.init()
  }
  
  func userContentController(
    _ userContentController: WKUserContentController,
    didReceive message: WKScriptMessage
  ) {
    guard let webViewMessage = WebViewMessage.parse(name: message.name, body: message.body) else {
      return
    }
    handler(webViewMessage)
  }
}

enum WebViewError: Error {
  case webViewNotInitialized
  case javaScriptEvaluationFailed
}

