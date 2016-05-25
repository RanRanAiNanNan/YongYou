//
//  ChoseCityViewController.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/3/17.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

protocol CityNameDelegate{
    func setCityname(cname:String);
}

class ChoseCityViewController :BaseTableViewController
{
    let areautile = AreaToListUtils.getInstance();
    var datalist = [String]();
    var pid:Int?;
    var delegate:CityNameDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
            self.initViewStyle();
            self.initData()
            self.view.backgroundColor = B.TABLEVIEW_BG
       
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datalist.count;
    }
    //MARK: 添加tableview cell 的内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CTY_CELL", forIndexPath: indexPath) 
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
        self.delegate?.setCityname(proname);
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func initData(){
        if(self.pid>3){
             datalist =  areautile.getCityList(self.pid!);
        }else{
             datalist =  areautile.getDistrictInfo(self.pid!);
        }
        
 
    }
    
    func initViewStyle(){
        initNav("选择省份")
        
    }
   
}
