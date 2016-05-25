//
//  IndentFanYongViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/31.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class IndentFanYongViewController: BaseViewController , UITableViewDataSource ,UITableViewDelegate
{
    
    var contractTableView :UITableView?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initView()
        
        
    }
    
    func initView(){
        
        initTableView()
        
    }
    
    func initTableView(){
        
        contractTableView =  UITableView(frame: CGRectMake(0,0, B.SCREEN_WIDTH , B.SCREEN_HEIGHT - 64 - 49 - 10), style: UITableViewStyle.Plain)
        self.view.addSubview(contractTableView!)
        contractTableView!.delegate = self
        contractTableView!.dataSource = self
        contractTableView!.registerClass(RichesCell.self, forCellReuseIdentifier: "IndentFanYongViewController")
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 10
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IndentFanYongViewController", forIndexPath: indexPath) as! RichesCell
        
        //名称
        cell.nameLabel?.text = "和聚鼎宝君享证券投资基金"
        //日期
        cell.dateLabel?.text = "2016-03-03"
        //审核
        cell.auditorLabel?.text = "预约成功"
        //钱
        cell.moneyLabel?.text = "100万"
        
        cell.cancelButton?.hidden = true
        cell.modificationButton!.setTitle("上传打款凭条", forState: UIControlState.Normal)
        cell.modificationButton!.setTitleColor(B.MENU_NORMAL_FONT_COLOR,forState: .Normal)
        cell.modificationButton!.layer.masksToBounds = true
        cell.modificationButton!.layer.borderWidth = 1
        cell.modificationButton!.hidden = true
//        cell.modificationButton!.addTarget(self,action:Selector("myDingDan:"),forControlEvents:.TouchUpInside)
        
        
        
        cell.fanyong!.text = "100万元"
        cell.fan!.text = "返佣金额"
        cell.xingmingLabel?.text = "韩冰"
        
        return cell;
    }
    
    func myDingDan(button : UIButton){
        
        print("上传打款凭条")
    }
    
    
}