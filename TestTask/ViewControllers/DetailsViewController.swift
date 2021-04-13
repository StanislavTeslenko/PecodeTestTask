//
//  DetailsViewController.swift
//  TestTask
//
//  Created by Stanislav Teslenko on 13.04.2021.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var dragView: UIView!
    
    var urlString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure WebView
        let url = URL(string: urlString) ?? URL(string: "apple.com")!
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        // Configure small horizontal view on top of the screen
        dragView.layer.cornerRadius = 5
        dragView.clipsToBounds = true
    }

}
