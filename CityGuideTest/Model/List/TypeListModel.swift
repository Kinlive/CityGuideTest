//
//  TypeListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/2.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

struct TypeListModel{
    
    private static var shared: TypeListModel = {
        
        let standard = TypeListModel(typeList: [])
        
//        print("初始化 cityList singleton")
        return standard
    }()
    
    static func standard() -> TypeListModel{
        
//        print("拿到singleton")
        
        return shared
    }
    
    
    
    
    var typeList: [Type]
    
    
    func toString(){
        
        print("總數：\(typeList.count)")
        
        for type in typeList{
            print(type.name)
//            print(type.id)
            print(type.number)
        }
        
        
    }
    
}

///City struct

struct Type{
    let number: String
    let name: String
//    var id: String
    
    init(json: [String: Any]){
        self.number = json["no"] as? String ?? ""
//        self.id = json["id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
    }
    
}
