//
//  IndentOrderViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/31.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class IndentOrderViewController: BaseViewController ,UITableViewDataSource ,UITableViewDelegate
{
    
    var contractTableView :UITableView?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initView()
        
        
    }
    
    func initView(){
        
        initSelectButton()
        initTableView()
        
    }
    
    
    
    
    func initSelectButton(){
        var arr = ["预约待审核","邮寄合同","返还合同"]
        for var i = 0 ; i < 3 ; i++ {
            let button : UIButton = UIButton(frame: CGRectMake(B.SCREEN_WIDTH  / 3 * CGFloat(Float(i)) , 0 , B.SCREEN_WIDTH  / 3,50 ))
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            button.setTitle(arr[i] , forState: UIControlState.Normal)
            button.tag = 20000 + i
            button.setTitleColor(B.NAV_TITLE_CORLOR, forState: UIControlState.Normal)
            button.addTarget(self,action:Selector("feiLeiButton:"),forControlEvents:.TouchUpInside)
            self.view.addSubview(button)
            
            let imageView : UIImageView = UIImageView(frame: CGRectMake(B.SCREEN_WIDTH  / 3 - 30, 0 , 30 ,50 ))
            imageView.image =  UIImage(named: "recharge_selectCard_icon")
            button.addSubview(imageView)
            
        }
    }
    
    
    func initTableView(){
        
        contractTableView =  UITableView(frame: CGRectMake(0,50, B.SCREEN_WIDTH , B.SCREEN_HEIGHT - 64 - 50 - 49 - 10), style: UITableViewStyle.Plain)
        self.view.addSubview(contractTableView!)
        contractTableView!.delegate = self
        contractTableView!.dataSource = self
        contractTableView!.registerClass(RichesCell.self, forCellReuseIdentifier: "IndentOrderViewController")
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IndentOrderViewController", forIndexPath: indexPath) as! RichesCell
        
        //名称
        cell.nameLabel?.text = "和聚鼎宝君享证券投资基金"
        //日期
        cell.dateLabel?.text = "2016-03-03"
        //审核
        cell.auditorLabel?.text = "预约待审核"
        //钱
        cell.moneyLabel?.text = "100万"
        
        cell.cancelButton!.setTitle("取消预约", forState: UIControlState.Normal)
        cell.modificationButton!.addTarget(self, action: Selector("xiugai:"), forControlEvents: .TouchUpInside)
        
        
        
        
        
        return cell;
    }

    func xiugai(button : UIButton){
        
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rpvc:FixAddressViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FixAddressViewController") as! FixAddressViewController
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

        
        
    }
    
    
    
    
}
