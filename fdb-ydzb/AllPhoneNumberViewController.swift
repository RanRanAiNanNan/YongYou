//
//  AllPhoneNumberViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/19.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
protocol MobileDelegate{
    
    func sendValue(value:String?)
}

class AllPhoneNumberViewController:BaseViewController , UITableViewDataSource ,UITableViewDelegate {
    
    var button2 : UIButton?
//    var image:UIImageView?
//    var image = UIImageView?()
    let geRenService = GeRenService.getInstance()
    var intt :Int!
    var phoneArr : NSArray!
    var tableView : UITableView!
    var delegate:MobileDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
    }
    override func viewWillAppear(animated: Bool) {
        self.loadingShow()
       
        geRenService.allPhone { (data) -> () in
            self.loadingHidden()
//            print("------\(data[0])")
            if (data as! NSArray).count != 0 {
                
                self.phoneArr = data as! NSArray
                self.tableView.reloadData()
            }else{
                self.phoneArr = data as! NSArray
            }
            
        }
        
    }

    
    
    
    
    
    func initView(){
        initNav("手机号")
        button2 = UIButton()
        intt = -1
        tableView =  UITableView(frame: CGRectMake(0,0, B.SCREEN_WIDTH , B.SCREEN_HEIGHT - 64 ), style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        self.view.addSubview(tableView!)
        tableView!.delegate = self
        tableView!.dataSource = self
//        tableView!.registerClass(AllPhoneCell.self, forCellReuseIdentifier: "AllPhoneNumberViewController")

        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.phoneArr == nil{
           return 0
        }else{
            return self.phoneArr.count
        }
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerClass(AllPhoneCell.self, forCellReuseIdentifier: "AllPhoneNumberViewController")
        
       let cell = tableView.dequeueReusableCellWithIdentifier("AllPhoneNumberViewController", forIndexPath: indexPath) as! AllPhoneCell
        
        if self.phoneArr == nil{
            return cell
        }else{
        cell.tag = indexPath.row
//        cell.accessoryType = UITableViewCellAccessorNone
        
       cell.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
       cell.mobileLabel?.text = self.phoneArr.objectAtIndex(indexPath.row).objectForKey("phoneNumb") as? String
       if self.phoneArr.objectAtIndex(indexPath.row).objectForKey("isDef") as! Int == 0{
        
        cell.xuanButton?.addTarget(self,action:Selector("myButton:"),forControlEvents:.TouchUpInside)
        cell.xuanButton?.setBackgroundImage(UIImage(named:"circle_selected"),forState:.Normal)
        cell.xuanButton?.tag = indexPath.row

       }else{
        cell.xuanButton?.addTarget(self,action:Selector("myButton:"),forControlEvents:.TouchUpInside)
        cell.xuanButton?.setBackgroundImage(UIImage(named:"circle"),forState:.Normal)
        cell.xuanButton?.tag = indexPath.row

            }
       
            
        return cell
        }
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let str1 = (self.phoneArr.objectAtIndex(indexPath.row).objectForKey("phoneNumb") as? String)!
        self.delegate?.sendValue(str1)
        self.navigationController?.popViewControllerAnimated(true)

    }
    func myButton(button:UIButton){
        
//        geRenService.xuanZeShouJiHao((self.phoneArr.objectAtIndex(button.tag).objectForKey("phoneNumb") as? String)!) { (data) -> () in
//            self.geRenService.allPhone { (data) -> () in
//                self.loadingHidden()
                //            print("------\(data[0])")
//                if (data as! NSArray).count != 0 {
        
//                    self.phoneArr = data as! NSArray
//                    self.tableView.reloadData()
                    let str1 = (self.phoneArr.objectAtIndex(button.tag).objectForKey("phoneNumb") as? String)!
                     self.delegate?.sendValue(str1)
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
//            }

            
//        }

        
//         UITableViewCell * cell = [self tableView:table cellForRowAtIndexPath:indexPath];
        
        
//        for var i = 0 ; i < 30 ; i++ {
//            if i  == button.tag  {
// 
//              print(button.tag)
//             
//                button.setBackgroundImage(UIImage(named:"circle_selected"),forState:.Normal)
//                let str1 = self.phoneArr.objectAtIndex(i) as? String
//                self.navigationController!.navigationBarHidden = false
//                print(str1)
//                delegate?.sendValue(str1)
//                self.navigationController?.popViewControllerAnimated(true)
//
//            
//                if  button.tag != intt{
//                button2!.setBackgroundImage(UIImage(named:"circle"),forState:.Normal)
//                
//                button2 = button
//                intt = button.tag
//                }
//                
//            }
//        
//        }
    
        
        
//    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        print("点点点")
//        
//        
//        
//    }

    
    
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController!.navigationBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}