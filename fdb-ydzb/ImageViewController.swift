//
//  ImageViewController.swift
//  fdb-ydzb
//
//  Created by 123 on 16/4/16.
//  Copyright © 2016年 然. All rights reserved.
//

import Foundation
class ImageViewController:BaseViewController {
    
    var myInt : Int!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initView()
        
        
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBarHidden = false
    }
    
    
    func initView(){
        
        self.navigationController!.navigationBarHidden = true
        print(myInt)
        if myInt == 1{
            imageView.image = UIImage(named: "签单流程1")
        }else if myInt == 2{
            imageView.image = UIImage(named: "签单流程2")
        }else if myInt == 3{
            imageView.image = UIImage(named: "签单流程3")
        }else if myInt == 4{
            imageView.image = UIImage(named: "签单流程4")
        }else if myInt == 5{
            imageView.image = UIImage(named: "签单流程5")
        }else if myInt == 6{
            imageView.image = UIImage(named: "签单流程6")
        }else if myInt == 7{
            imageView.image = UIImage(named: "签单流程7")
        }else if myInt == 8{
            imageView.image = UIImage(named: "签单流程8")
        }else if myInt == 9{
            imageView.image = UIImage(named: "签单流程9")
        }else if myInt == 10{
            imageView.image = UIImage(named: "签单流程10")
        }
        
        
        
    }

    
    @IBAction func back(sender: AnyObject) {
         self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}