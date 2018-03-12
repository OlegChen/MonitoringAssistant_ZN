//
//  lawVCViewController.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import WebKit

class lawVCViewController: BaseVC {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "法律条款"
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 0, 0))
            
        }
        
        let path = Bundle.main.path(forResource: "中能云管家", ofType: "html")
        let urlStr = NSURL.fileURL(withPath: path!)
        webView.load(URLRequest.init(url: urlStr)) ///t(NSURLRequest(URL: urlStr))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
