//
//  GongGaoWebViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/5/16.
//  Copyright © 2016年 然. All rights reserved.
//

class GongGaoWebViewController:BaseViewController {
    

    @IBOutlet weak var webView: UIWebView!
    
    var passUrl : String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        print(passUrl)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 38/255, green: 38/255, blue: 40/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 91/255, green: 95/255, blue: 110/255, alpha: 1)
        self.navigationController?.navigationBar.translucent = false
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lab.text = "公告"
        lab.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = lab
        //设置标题颜色
        _ = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        //self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        //self.view.backgroundColor = B.VIEW_BG
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

//        web.loadRequest(NSURLRequest(URL:NSURL(string:"http://\(passUrl)")!))
        webView.loadRequest(NSURLRequest(URL:NSURL(string:"http://121.43.118.86:10220/index.php/home/Index/announcement?id=\(passUrl)")!))
    }
    
    
}