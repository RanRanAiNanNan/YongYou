//
//  GuideController.swift
//  ydzbapp-hybrid
//  引导页
//  Created by 刘驰 on 15/1/27.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class GuideViewController:UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var numOfPages = 4
    
    @IBOutlet weak var versionLab: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSizeMake(CGFloat(CGRectGetWidth(self.view.bounds)) * CGFloat(numOfPages) , CGRectGetHeight(self.view.bounds))
        scrollView.backgroundColor = UIColor.grayColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = true
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
        let version = infoDict.objectForKey("CFBundleShortVersionString") as! String
        let build = infoDict.objectForKey("CFBundleVersion") as! String
        versionLab.text = "version:" + version + " build:" + build
        
        _ = scrollView.bounds.size
        for i in 0 ..< numOfPages {
            let page = UIView()
            let pimg:UIImageView = UIImageView(image:UIImage(named: "guide_0" + String(i+1)))
            pimg.bounds.size.width = self.view.bounds.size.width
            pimg.frame = CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.bounds), height: CGRectGetHeight(self.view.bounds))
            pimg.bounds.size.height = self.view.bounds.size.height
            page.frame = CGRect(x: CGFloat(i) * self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            page.addSubview(pimg)
            scrollView.addSubview(page)
            let loginBtn = UIButton(frame: CGRect(x: (3 * self.view.bounds.width)+40, y: self.view.bounds.height-90, width: self.view.bounds.width-80, height: 45))
            
            loginBtn.setTitle("开始赚钱", forState: UIControlState.Normal)
            loginBtn.backgroundColor = UIColor(red: 72/255, green: 75/255, blue: 90/255, alpha: 1)
            loginBtn.titleLabel?.font = UIFont.systemFontOfSize(20.0)
            loginBtn.tintColor = UIColor.whiteColor()
            loginBtn.layer.cornerRadius = 20
            loginBtn.addTarget(self, action: "tologin:", forControlEvents: UIControlEvents.TouchUpInside)
            scrollView.addSubview(loginBtn)
        }
        pageControl.backgroundColor = UIColor.clearColor()
        pageControl.numberOfPages = numOfPages
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func tologin(sender: UIButton!){
        userDefaultsUtil.setFirstLogged()
        self.performSegueWithIdentifier("guideTologinSegue", sender: self)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
        
    }
    
    func pageChanged(sender:UIPageControl){
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue is CustomSegue {
            (segue as! CustomSegue).animationType = .Push
        }
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        segue.animationType = .Push
        return segue
    }
    
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        var twidth = CGFloat(numOfPages - 1) * self.view.bounds.size.width
    //
    //        if scrollView.contentOffset.x > twidth {
    //            userDefaultsUtil.setFirstLogged()
    //            //self.performSegueWithIdentifier("guideTologinSegue", sender: self)
    //        }
    //    }
    
    
}
