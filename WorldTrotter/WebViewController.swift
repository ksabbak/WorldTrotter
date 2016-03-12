//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by k_sabbak on 3/11/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController
{
    var webView: WKWebView!
    
    override func loadView()
    {
        webView = WKWebView()
        
        //The view
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://bignerdranch.com")!
        webView.loadRequest(NSURLRequest(URL: url))
    }
}