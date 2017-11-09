//
//  TypeDetailListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/6.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

struct TypeDetailListModel{
    
    private static var shared: TypeDetailListModel = {
        
        let standard = TypeDetailListModel(typeDetailList: [])
        
        //        print("初始化 cityList singleton")
        return standard
    }()
    
    static func standard() -> TypeDetailListModel{
        
        //        print("拿到singleton")
        
        return shared
    }
    
    
    
    
    var typeDetailList: [TypeDetailObject]
    
    
    func toString(){
        
        print("總數：\(typeDetailList.count)")
        
//        for typeDetail in typeDetailList{
//            print(typeDetail.name)
//            print(typeDetail.id)
//            print(typeDetail.number)
//        }
        
        
    }
    
}

///Type struct

struct TypeDetailObject{
    let number: String
    let name: String
    let id: String
    let city: String
    let img: String
    let imgTitle: String
    let content: String
    let summary: String
    let poi: [String]
    let zip: String
    let address: String
    let openhours: String
    let phone: String
    let email: String
    let web: String
    let tag: String
    let picture: String
    let pictureTitle: String
    let map: String
    let panorama: String
    let youtube: String
    let guideMap: String
    let storyImg: String
    
    init(json: [String: Any]){
        self.number = json["no"] as? String ?? ""
        self.id = json["id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.city = json["city"] as? String ?? ""
        self.img = json["img"] as? String ?? ""
        self.imgTitle = json["imgtitle"] as? String ?? ""
        self.content = json["content"] as? String ?? ""
        self.summary = json["summary"] as? String ?? ""
        
        let poiArray = TypeDetailObject.handleStringToArray(jsonStr: json["poi"] as? String ?? "")
        self.poi = poiArray
        
        self.zip = json["zip"] as? String ?? ""
        self.address = json["address"] as? String ?? ""
        self.openhours = json["openhours"] as? String ?? ""
        self.phone = json["phone"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.web = json["web"] as? String ?? ""
        self.tag = json["tag"] as? String ?? ""
        self.picture = json["picture"] as? String ?? ""
        self.pictureTitle = json["picturetitle"] as? String ?? ""
        self.map = json["map"] as? String ?? ""
        self.panorama = json["panorama"] as? String ?? ""
        self.youtube = json["youtube"] as? String ?? ""
        self.guideMap = json["guidemap"] as? String ?? ""
        self.storyImg = json["storyimg"] as? String ?? ""
        
    }
    
    
    private static func handleStringToArray(jsonStr: String) -> [String] {
        
        guard let jsonData = jsonStr.data(using: .utf8) else {return [] }
        var strArray: [String]?
        
        do{
            strArray = [String]()
            
            strArray = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String]
            
            
        }catch let jsonError{
            
            print("Poi is nil :\(jsonError.localizedDescription)")
            
        }
        
        guard let finalStrArray = strArray else {
            print("Array is nil")
            return [] }
        
        return finalStrArray
        
    }
    
}
