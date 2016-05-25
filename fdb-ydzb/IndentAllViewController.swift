//
//  IndentAllViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/31.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class IndentAllViewController: BaseViewController , UITableViewDataSource ,UITableViewDelegate
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
        
        contractTableView =  UITableView(frame: CGRectMake(0,0, B.SCREEN_WIDTH , B.SCREEN_HEIGHT - 69 - 49 - 10 ), style: UITableViewStyle.Plain)
        self.view.addSubview(contractTableView!)
        contractTableView!.delegate = self
        contractTableView!.dataSource = self
        contractTableView!.registerClass(RichesCell.self, forCellReuseIdentifier: "IndentAllViewController")
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IndentAllViewController", forIndexPath: indexPath) as! RichesCell
        
        //名称
        cell.nameLabel?.text = "和聚鼎宝君享证券投资基金"
        //日期
        cell.dateLabel?.text = "2016-03-03"
        //审核
        cell.auditorLabel?.text = "预约待审核"
        cell.cancelButton!.setTitle("取消预约", forState: UIControlState.Normal)
        
        //钱
        cell.moneyLabel?.text = "100万"
        
        
        
        
        
        
        return cell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:ParticularsViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("ParticularsViewController") as! ParticularsViewController
        //        rpvc.str = "aaa"
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)
        
        
    }

    
}
