//
//  StringExtension.swift
//  ydzbapp-hybrid
//
//  Created by qinxin on 15/12/10.
//  Copyright © 2015年 银多资本. All rights reserved.
//

import UIKit

//Helper
extension String {
    subscript (index: Int) -> Character {
        return self[self.startIndex.advancedBy(index)]
    }
}

class StringExtension: NSObject {

}
