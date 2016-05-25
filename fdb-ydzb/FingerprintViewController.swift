//
//  FingerprintViewController.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 16/3/3.
//  Copyright © 2016年 银多资本. All rights reserved.
//

import Foundation
import UIKit

class FingerprintViewController: BaseViewController {
    
    @IBOutlet weak var fingerSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fingerSwitch.on = userDefaultsUtil.getFingerprint()
        initView()
    }
    
    @IBAction func switchClick(sender: UISwitch) {
        if sender.on {
            KGXToast.showToastWithMessage("开启指纹解锁", duration: ToastDisplayDuration.LengthShort)
            userDefaultsUtil.setFingerprint(sender.on)
        }else{
            KGXToast.showToastWithMessage("关闭指纹解锁", duration: ToastDisplayDuration.LengthShort)
            userDefaultsUtil.setFingerprint(sender.on)
        }
    }
    
    private func initView() {
        initNav("指纹解锁")
    }
}