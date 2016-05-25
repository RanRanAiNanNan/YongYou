//
//  BannerWebViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/5/15.
//  Copyright © 2016年 然. All rights reserved.
//

class BannerWebViewController:BaseViewController {
    
    @IBOutlet weak var web: UIWebView!
    
    var passUrl : String!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(passUrl)
         web.loadRequest(NSURLRequest(URL:NSURL(string:"http://\(passUrl)")!))
        
    }
    
    
}