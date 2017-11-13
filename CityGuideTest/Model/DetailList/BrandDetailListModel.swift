//
//  BrandDetailListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/6.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

///Save BrandDetailList struct.
struct BrandDetailListModel{
    
    ///BrandDetailListModel's singleton.
    private static var shared: BrandDetailListModel = {
        
        let standard = BrandDetailListModel(brandDetailList: [])

        return standard
    }()
    
    ///Get CityDetailListModel standard singleton.
    static func standard() -> BrandDetailListModel{
        
        return shared
    }
    
    
    
    ///Save every struct of BrandDetail.
    var brandDetailList: [BrandDetailObject]
    
    
    func toString(){
        
        print("總數：\(brandDetailList.count)")
        
//        for brandDetail in brandDetailList{
//            print(brandDetail.name)
//            print(brandDetail.id)
//            print(brandDetail.number)
//        }
        
        
    }
    
}

///Save every detail infomation,it most detail to look on  http://bit.ly/2hX6sI7
struct BrandDetailObject{
    let number: String
    let name: String
    let id: String
    let city: String
    let img: [String]
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
        self.img = BrandDetailObject.handleStringToArray(jsonStr: json["img"] as? String ?? "")
        self.imgTitle = json["imgtitle"] as? String ?? ""
        self.content = json["content"] as? String ?? ""
        self.summary = json["summary"] as? String ?? ""
        let poiArray = BrandDetailObject.handleStringToArray(jsonStr: json["poi"] as? String ?? "")
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
    
    /**
     It's to transfer the json's back data like string but we want it to array.
     - Parameter jsonStr: Json back data.
     - Returns: Transfer to array
     */
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
