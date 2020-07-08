//
//  WebViewViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 08/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import WebKit

enum WebViewType {
    case PrivacyPolicy
    case AboutUs
    case ContactUs
}

class WebViewViewController: SPBaseViewController {

    var webView : WKWebView!
    var type: WebViewType = .PrivacyPolicy
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        view = webView
        var url = "https://stageprogram.com/privacy"
        switch self.type {
        case .PrivacyPolicy:
            url = "https://stageprogram.com/privacy"
        case .AboutUs:
            url = "https://stageprogram.com/about"
        case .ContactUs:
            url = "https://stageprogram.com/contact"
        }
        self.loadURL(url: url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handleLeftBarButtonItem(leftButtonType: .WhiteBack)
    }
    
    func loadURL(url: String) {
        if let url = URL(string: url) {
            self.webView.load(URLRequest(url: url))
            self.webView.allowsBackForwardNavigationGestures = true
        }
    }
}

extension WebViewViewController : WKNavigationDelegate {
    
}
