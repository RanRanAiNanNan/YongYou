//
//  DaoShouMoneyViewcontroller.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/12.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class DaoShouMoneyViewcontroller:BaseViewController {

    let geRenService = GeRenService.getInstance()
    var dic = NSArray()
    
    @IBOutlet weak var daoShouLB: UILabel!
    @IBOutlet weak var tiXianLB: UILabel!
    @IBOutlet weak var moneyLB: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.loadingShow()
        geRenService.yuE { (data) -> () in
            if (data as? NSArray)?.count != 0{
             self.loadingHidden()
            self.dic = (data as? NSArray)!
            let str = self.dic[0]
            print("\(str)")
            
            if self.dic[0] as! NSObject == 0{
                self.daoShouLB.text = "￥0.00"
                self.moneyLB.text = "￥0.00"
            }else{
                self.moneyLB.text = "￥\(self.dic[0])"
                self.daoShouLB.text = "￥\(self.dic[0])"
                print(self.dic[0] )
                print(self.dic[1] )
            }
            if self.dic[1] as! NSObject == 0 {
                self.tiXianLB.text = "￥0.00"
            }else{
                self.tiXianLB.text = "￥\( self.dic[1] )"
            }
            }else{
                
            }
        }
    }

    func initView(){
        
        self.navigationController!.navigationBarHidden = true
    }

    @IBAction func backReturn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    


    @IBAction func tiXian(sender: AnyObject) {
        
        if self.dic.count == 0{
            
        }else{
        
        print(self.dic[1] as! CGFloat)
        let oneStoryBoard:UIStoryboard = UIStoryboard(name: "My", bundle: NSBundle.mainBundle())
        let rpvc:FanXianViewController = oneStoryBoard.instantiateViewControllerWithIdentifier("FanXianViewController") as! FanXianViewController
        if self.dic[1] as! CGFloat == 0{
           rpvc.money = "0.00"
        }else{
        rpvc.money = "\(self.dic[1])"
            print(rpvc.money)
        }
        rpvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(rpvc, animated: true)

    }
    }



}