//
//  AssociaTionMobileViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/29.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class AssociaTionMobileViewController:BaseViewController , UITableViewDataSource , UITableViewDelegate {
    var mobileTableView : UITableView!
    
    var mobileArr : NSMutableArray?

    var duihaoImage :UIImageView?
    
    var duihao : CGFloat?
    override func viewDidLoad() {
        initView()
        let myUserDefaultes :NSUserDefaults = NSUserDefaults.standardUserDefaults()
        self.mobileArr = myUserDefaultes.objectForKey("myPhoneNumber") as? NSMutableArray

    }
    func initView(){
        initNav("关联手机")
        initTableView()
    }
    func initTableView(){
        mobileTableView =  UITableView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height ), style: UITableViewStyle.Plain)
        self.view.addSubview(mobileTableView)
        mobileTableView.delegate = self
        mobileTableView.dataSource = self
        mobileTableView.registerClass(MObileCell.self, forCellReuseIdentifier: "mobilecell")
        
        //对号
//        duihaoImage = UIImageView(frame: CGRectMake(B.SCREEN_WIDTH - 30 , 20, 20, 20))
//        duihaoImage!.image = UIImage(named: "recharge_selectCard_icon")
//        mobileTableView.addSubview(duihaoImage!)
        

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.mobileArr?.count)!
    }
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("mobilecell", forIndexPath: indexPath) as! MObileCell
        
        cell.nameLabel.text = "手机号码" //self.mobileArr?.objectAtIndex(indexPath.row ).objectForKey("name") as? String
        cell.mobileLabel.text = self.mobileArr?.objectAtIndex(indexPath.row ).objectForKey("number") as? String
        
        
        return cell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        duihaoImage?.frame = (frame: CGRectMake(B.SCREEN_WIDTH - 30 ,CGFloat(Float(indexPath.row)) * 70 + 20, 20 , 20))
        print(CGFloat(Float(indexPath.row)) * 50 + 20)
 
    }
   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
//        //删除数据源的对应数据
//        dataScoure.removeAtIndex(indexPath.row)
//        
        //删除对应的cell
//        self.mobileTableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    
//        //数据源为空的时候管理按钮不能删除
//        if self.dataScoure.count == 0{
//            barButtonItem?.enabled = false;
        }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        return "删除"
    }


    
    
    
    
    
    
    
    
    
    
    
    

}