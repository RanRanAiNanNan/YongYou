//
//  DingDanXiangQingViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/3/30.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class DingDanXiangQingViewController: BaseViewController {


    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initView()
        
    }
    
    func initView(){
        initNav("订单详情111")
//        super.view.frame = (frame: CGRectMake(100 , 60 , 100,50 ))
//        myTableView =  UITableView(frame: CGRectMake(0,(B.SCREEN_HEIGHT - 49 - 88) / 2 + 1, B.SCREEN_WIDTH , B.SCREEN_HEIGHT -  (B.SCREEN_HEIGHT - 49 - 88) / 2 - 50), style: UITableViewStyle.Plain)
//        myTableView.delegate = self
//        myTableView.dataSource = self
//        myTableView.registerClass(RichesCell.self, forCellReuseIdentifier: "aaaaa")
    }

  
}
