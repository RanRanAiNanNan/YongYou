//
//  NameGengGaiViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/5/10.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class NameGengGaiViewController:BaseViewController {
    
    @IBOutlet weak var textField: UITextField!
    var regMobile : String!
    var name : String!
    let homeService = HomeService.getInstance()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        textField.delegate = self
//        textField.text = userDefaultsUtil.getMobile()
        if regMobile == name{
          textField.text = ""
        }else{
          textField.text = name
        }
        
    }
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    func initView(){
        
        self.navigationController!.navigationBarHidden = true
    }
    @IBAction func back(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func tiJiao(sender: AnyObject) {
        textField.resignFirstResponder()

        if textField.text == ""{
            KGXToast.showToastWithMessage("昵称不能为空", duration: ToastDisplayDuration.LengthShort)
        
        }else if userDefaultsUtil.getMobile() == textField.text {
            KGXToast.showToastWithMessage("昵称已存在", duration: ToastDisplayDuration.LengthShort)
        }else{
        
        homeService.fixName(self.textField.text!) { (data) -> () in
            if data as! String == "1"{
                userDefaultsUtil.setMobile(self.textField.text!)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }

    }
    }
    
    
}
