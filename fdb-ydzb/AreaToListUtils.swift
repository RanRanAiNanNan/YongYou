//
//  AreaToList.swift
//  ydzbapp-hybrid
//
//  Created by yinduo-zdy on 15/3/12.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
//mark: -省市区数据格式化


class AreaToListUtils {
    //MARK: INIT AGUMENTS
    var prolist:Array<String>= Array<String>();
    var ctylist:Array<String>= Array<String>();
    var districtlist:Array<String>= Array<String>();
     //MARK: BASE DICTIONARY INIT
    func initData() ->NSDictionary{
        //1. 读取plist文件

        let settingPath = NSBundle.mainBundle().pathForResource("area", ofType: "plist");
        let settingDict = NSDictionary(contentsOfFile: settingPath!);
               //let provtemp = allkey?.sorted{$0 < $1};
        return settingDict!
        
    }
    
    //MARK: PROVINCE QUERY AND GETTER METHOD
    func queryProvInfo(){
        let provinceDict = self.initData();
        let provincekeys:Array = provinceDict.allKeys;
        var provincekeys_sorted :Array = provincekeys.sort{ $1.integerValue > $0.integerValue};
        
        
        for(var i:Int = 0 ;i<provincekeys_sorted.count;i++){
            let indx:String = provincekeys_sorted[i] as! String;
            let nary:Array = provinceDict.objectForKey(indx)!.allKeys;
            prolist.append(nary[0] as! String);
        }
    }
    
    func getProvInfo() -> Array<String>{
        self.queryProvInfo();
        let prlist:Array<String> = self.prolist;
        return prlist;
    }
    
    //MARK: CITY QUERY AND GETTER METHOD
    func queryctyInfo(a:Int){
       
        ctylist = []
        self.queryProvInfo();
        let chosedprovance = prolist[a];
        let settingDict:NSDictionary = self.initData();
        let row:String = String(a);
        let province_dict:NSDictionary = settingDict.objectForKey(row) as! NSDictionary;  //int_key关联的－省名为key的字典
        let ctydict:NSDictionary = province_dict.objectForKey(chosedprovance) as! NSDictionary; // 省名key关联的－int_key的市字典
        let citykays : NSArray = ctydict.allKeys;
        let citykays_sorted: NSArray = citykays.sort{$1.integerValue>$0.integerValue};
        for(var i:Int = 0;i < citykays_sorted.count;i++){
            let indx:String = citykays_sorted[i] as! String;
            let nary:Array = ctydict.objectForKey(indx)!.allKeys;
            ctylist.append(nary[0] as! String);

        }
        
    }
    
    func getCityList(provincerow:Int)->Array<String>{
        self.queryctyInfo(provincerow);
         let ctlist:Array<String> = self.ctylist;
        return ctlist
    }
    
     //MARK: DISTICT QUERY AND GETTER METHOD
    func getDistrictInfo(provincerow:Int)->Array<String>{
  
        self.queryProvInfo();
        let chosedprovance = prolist[provincerow];
        let settingDict:NSDictionary = self.initData();
        let row:String = String(provincerow);
        let province_dict:NSDictionary = settingDict.objectForKey(row) as! NSDictionary;  //int_key关联的－省名为key的字典
        let ctydict:NSDictionary = province_dict.objectForKey(chosedprovance) as! NSDictionary; // 省名key关联的－int_key的市字典
        // 1. 直辖市只有一个城市 所以直接 ctydict.objectForKey(0)
        let cityNames:Array = ctydict.objectForKey("0")!.allKeys;
        /* 2. 普通的省，需要循环获取每一个城市的名称
        
        let citykays : NSArray = ctydict.allKeys;
        let citykays_sorted: NSArray = sorted(citykays){$1.integerValue>$0.integerValue};
        for(var i:Int = 0;i < citykays_sorted.count;i++){
            var indx:String = citykays_sorted[i] as String;
            let nary:Array = ctydict.objectForKey(indx)!.allKeys;
            ctylist.append(nary[0] as String);
        
        }*/

        
        let cityname:String = cityNames[0] as! String;
        let dictictDict:NSDictionary = ctydict.objectForKey("0") as! NSDictionary;
        let dictrictArray : Array<String> = dictictDict[cityname] as! Array<String>;
        return dictrictArray;
    }
    
    
   class func getInstance() -> AreaToListUtils{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:AreaToListUtils? = nil
        }
        dispatch_once(&Singleton.predicate,{
            Singleton.instance=AreaToListUtils()
            }
        )
        return Singleton.instance!
    }
}
