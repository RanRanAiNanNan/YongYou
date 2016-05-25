//
//  ChoseProvinceViewController.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/3/16.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

protocol ProvinceNameDelegate{
    func setProvincename(pname:String,pindex:Int);
}

class ChoseProvinceViewController: BaseTableViewController {

 

   let areautile = AreaToListUtils.getInstance();
     var datalist = [String]();
    var delegate:ProvinceNameDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.initData();
        self.initViewStyle();
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datalist.count;
    }
    //MARK: 添加tableview cell 的内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("PRO_CELL", forIndexPath: indexPath) 
        //名称
        let tile:UILabel = cell.viewWithTag(10) as! UILabel!
        tile.text = self.datalist[indexPath.row];
        //tile.textColor = UIColor.whiteColor();
        //cell被点击后的透明背景
        let xxview:UIView = UIView(frame: CGRect(x: 0,y: 0,width: cell.bounds.width,height: cell.bounds.height));
        xxview.backgroundColor = UIColor(red: 20/255, green: 38/255, blue: 55/255, alpha: 1)
        cell.selectedBackgroundView = xxview;
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    //MARK: cell 选中触发事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       
        let proname:String = datalist[indexPath.row];
         
        self.delegate?.setProvincename(proname,pindex: indexPath.row);
       
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func initData(){
        datalist =  areautile.getProvInfo()
        
    }
    
    func initViewStyle(){
        initNav("选择省份")
        
    }

}
