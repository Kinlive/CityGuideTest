//
//  cityDetailListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/3.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

struct CityDetailListModel{
    
    private static var shared: CityDetailListModel = {
        
        let standard = CityDetailListModel(cityDetailList: [])
        
        //        print("初始化 cityList singleton")
        return standard
    }()
    
    static func standard() -> CityDetailListModel{
        
        //        print("拿到singleton")
        
        return shared
    }
    
    
    
    
    var cityDetailList: [CityDetailObject]
    
    
    func toString(){
        
        print("總數：\(cityDetailList.count)")
        
        for cityDetail in cityDetailList{
            print(cityDetail.name)
            print(cityDetail.id)
            print(cityDetail.number)
        }
        
        
    }
    
}

///City struct

struct CityDetailObject{
    let number: String
    let name: String
    let id: String
    let city: String
    let img: String
    let imgTitle: String
    let content: String
    let summary: String
    let poi: String
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
    
    init(json: [String: Any]){
        self.number = json["no"] as? String ?? ""
        self.id = json["id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.city = json["city"] as? String ?? ""
        self.img = json["img"] as? String ?? ""
        self.imgTitle = json["imgtitle"] as? String ?? ""
        self.content = json["content"] as? String ?? ""
        self.summary = json["summary"] as? String ?? ""
        self.poi = json["poi"] as? String ?? ""
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
        
        
    }
    
}
