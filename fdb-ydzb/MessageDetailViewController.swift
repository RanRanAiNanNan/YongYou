//
//  MessageDetailViewController.swift
//  ydzbapp-hybrid
//  消息记录详情
//  Created by 刘驰 on 15/2/10.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import UIKit

class MessageDetailViewController: BaseViewController {

    @IBOutlet weak var msgLabel: UILabel!               //消息内容
    
    var mm:MessageRecordModel!
    
    var id: String = ""
    
    let service = MessageService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        initNav("详细消息")
        if id == "" {
            msgLabel.text = mm.content
        }else{
//            service.loadDataGet(id, calback: { (data) -> () in
//                let model = data as! MessageModel
//                self.msgLabel.text = model.content
//            })
        }
        
    }
    

}
