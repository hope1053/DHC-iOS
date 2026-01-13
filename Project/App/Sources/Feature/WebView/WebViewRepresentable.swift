//
//  WebViewRepresentable.swift
//  Flifin
//
//  Created by hyerin on 1/13/26.
//

import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
  let configuration: WKWebViewConfiguration
  
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView(frame: .zero, configuration: configuration)
    
    webView.scrollView.minimumZoomScale = 1.0
    webView.scrollView.maximumZoomScale = 1.0
    webView.isInspectable = true
    
    WebViewCoordinator.shared.setWebView(webView)
    
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {}
}
