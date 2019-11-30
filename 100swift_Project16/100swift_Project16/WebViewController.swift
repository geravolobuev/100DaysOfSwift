//
//  WebViewController.swift
//  100swift_Project16
//
//  Created by MAC on 26/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var wikiCity: String = "Russia"
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let url = URL(string: "https://en.wikipedia.org/wiki/" + wikiCity)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }

}
