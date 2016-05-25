//
//  ChoseBankViewController.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/3/11.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

protocol choseBankDelegate{
    func setBankName(bankname:String);
}

class ChoseBankViewController:BaseTableViewController {
    
    var banklist = []
    let userSafetyService =  UserSafetyInfoService.getInstance()
    var delegate:choseBankDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewStyle()
        //self.dataLoad()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.banklist.count;
    }
    
    //MARK: 添加tableview cell 的内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("BANK_CELL", forIndexPath: indexPath) 
        //名称
        let tile:UILabel = cell.viewWithTag(10) as! UILabel
        tile.text = self.banklist[indexPath.row] as? String;
        
        //cell被点击后的透明背景
        //        let xxview:UIView = UIView(frame: CGRect(x: 0,y: 0,width: cell.bounds.width,height: cell.bounds.height));
        //        xxview.backgroundColor = UIColor(red: 20/255, green: 38/255, blue: 55/255, alpha: 1)
        //        cell.selectedBackgroundView = xxview;
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    //MARK: cell 选中触发事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bkname:String = banklist[indexPath.row] as! String
        self.delegate?.setBankName(bkname);
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    
//    func dataLoad(){
//        //   let provlist = atl.getProvInfo();
//        banklist = userSafetyService.getBanklist();
//    }
    
    func initViewStyle(){
        initNav("选择银行")
    }
}
