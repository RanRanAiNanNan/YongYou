import Foundation

extension String {
    
    //Encode base64
    func base64Encoded() -> String {
        let plainData = self.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions([])
        return base64String!
    }
    
    //Decode base64
    func base64Decoded() -> String {
        let decodedData = NSData(base64EncodedString: self, options: [])
        let decodedString = "" //NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
        return decodedString as! String
    }
    
}