//
//  PhotoUtils.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/5/16.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class PhotoUtils {
    
    /** 保存头像 **/
    class func saveImage(image:UIImage) {
        var success = false
        let fileManager = NSFileManager.defaultManager()
        let error = NSErrorPointer()
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as NSString
        let imageFilePath = documentsDirectory.stringByAppendingPathComponent("avatar.png")
        success = fileManager.fileExistsAtPath(imageFilePath)
        if success {
            do {
                try fileManager.removeItemAtPath(imageFilePath)
            } catch let error1 as NSError {
                error.memory = error1
            }
        }
        let smallImage = thumbnailWithImageWithoutScale(image, toSize: CGSizeMake(60, 60))
        UIImagePNGRepresentation(smallImage)!.writeToFile(imageFilePath, atomically: true)
    }
    
    
    class func thumbnailWithImageWithoutScale(image:UIImage, toSize size:CGSize) -> UIImage {
        var newImage = UIImage()
        let oldsize = image.size
        var rect = CGRect()
        if size.width / size.height > oldsize.width / oldsize.height {
            rect.size.width = size.height * (oldsize.width / oldsize.height)
            rect.size.height = size.height
            rect.origin.x = (size.width - rect.size.width) / 2
            rect.origin.y = 0
        }else{
            rect.size.width = size.width;
            rect.size.height = size.width * (oldsize.height / oldsize.width);
            rect.origin.x = 0;
            rect.origin.y = (size.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,UIColor.clearColor().CGColor)
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        image.drawInRect(rect)
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    
    //加载本地头像
    class func showAvatar() -> UIImage {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as NSString
        let imageFilePath = documentsDirectory.stringByAppendingPathComponent("avatar.png")
        let avatarImg = UIImage(contentsOfFile: imageFilePath)
        if avatarImg != nil {
            return avatarImg!
        }else{
            return UIImage(named: "Avatar@2x(1)")!
        }
    }
    
    
    class func uploadAvatar(url:String, parameters:Dictionary<String, String>){
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as  NSString
        let imageFilePath = documentsDirectory.stringByAppendingPathComponent("avatar.png")
        let saveAvatarImg = UIImage(contentsOfFile: imageFilePath)
        let imageData = UIImagePNGRepresentation(saveAvatarImg!)

        
        let urlRequest = urlRequestWithComponents(url, parameters: parameters, imageData: imageData!)
        
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .response { (request, response, data, error) in
                if error == nil{
                    var json = JSON(data!)
                    let status = json["status"].stringValue
                    let msg = json["msg"].stringValue
                    let avatar = json["avatar"].stringValue
                    if status == "1" {
                        userDefaultsUtil.setAvatarLink(avatar)
                    }
                    KGXToast.showToastWithMessage(msg, duration: ToastDisplayDuration.LengthShort)
                }else{
                    KGXToast.showToastWithMessage("上传头像失败", duration: ToastDisplayDuration.LengthShort)
                }
        }
        
    }
    
    
    class func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        // create upload data to send
        let uploadData = NSMutableData()
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
}