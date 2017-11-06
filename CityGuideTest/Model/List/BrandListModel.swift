//
//  BrandListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/3.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation
struct BrandListModel{
    
    private static var shared: BrandListModel = {
        
        let standard = BrandListModel(brandList: [])
        
        //        print("初始化 cityList singleton")
        return standard
    }()
    
    static func standard() -> BrandListModel{
        
        //        print("拿到singleton")
        
        return shared
    }
    
    
    
    
    var brandList: [Brand]
    
    
    func toString(){
        
        print("總數：\(brandList.count)")
        
        for brand in brandList{
            print(brand.name)
            print(brand.id)
            print(brand.number)
        }
        
        
    }
    
}

///City struct

struct Brand{
    let number: String
    let name: String
    let id: String
    
    init(json: [String: Any]){
        self.number = json["no"] as? String ?? ""
        self.id = json["id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
    }
    
}
