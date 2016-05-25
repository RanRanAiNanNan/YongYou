//
//  ModalView.swift
//  PathDynamicModal-Demo
//
//  Created by Ryo Aoyama on 2/11/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class ModalView: UIView, UIWebViewDelegate {
    var bottomButtonHandler: (() -> Void)?
    var closeButtonHandler: (() -> Void)?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet private weak var bottomButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var infoWebView: UIWebView!
    
    @IBOutlet weak var loadingAv: UIActivityIndicatorView!
    
    
    class func instantiateFromNib() -> ModalView {
        let view = UINib(nibName: "ModalView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! ModalView
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    func loadUrl(url:String){
        let urlobj = NSURL(string: url)
        let request = NSURLRequest(URL: urlobj!)
        self.infoWebView.loadRequest(request)
    }
    
    private func configure() {
        self.contentView.layer.cornerRadius = 5.0
        self.bottomButton.layer.cornerRadius = 5
//        self.closeButton.layer.cornerRadius = CGRectGetHeight(self.closeButton.bounds) / 2.0
//        self.closeButton.layer.shadowColor = UIColor.blackColor().CGColor
//        self.closeButton.layer.shadowOffset = CGSizeZero
//        self.closeButton.layer.shadowOpacity = 0.3
//        self.closeButton.layer.shadowRadius = 2.0
        self.loadingAv.hidden = true
        self.infoWebView.delegate = self
    }
    
    @IBAction func handleBottomButton(sender: UIButton) {
        self.bottomButtonHandler?()
    }
    @IBAction func handleCloseButton(sender: UIButton) {
        self.closeButtonHandler?()
    }
    
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.loadingAv.hidden = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingAv.hidden = true
    }
}