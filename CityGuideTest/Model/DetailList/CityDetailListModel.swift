//
//  cityDetailListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/3.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

///Save CityDetailList struct.
struct CityDetailListModel{
    
    ///CityDetailListModel's singleton.
    private static var shared: CityDetailListModel = {
        
        let standard = CityDetailListModel(cityDetailList: [])
   
        return standard
    }()
    
    ///Get CityDetailListModel standard singleton.
    static func standard() -> CityDetailListModel{
        
        return shared
    }
    
    
    
    ///Save every struct of CityDetail.
    var cityDetailList: [CityDetailObject]
    
    
    func toString(){
        
        print("總數：\(cityDetailList.count)")
        
//        for cityDetail in cityDetailList{
//            print(cityDetail.name)
//            print(cityDetail.id)
//            print(cityDetail.number)
//        }
        
        
    }
    
}

///Save every detail infomation,it most detail to look on  http://bit.ly/2hX6sI7
struct CityDetailObject{
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
    let youtube: [String]
    let guideMap: [String]
    let storyImg: String
    
    
    init(json: [String: Any]){
        self.number = json["no"] as? String ?? ""
        self.id = json["id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.city = json["city"] as? String ?? ""
        
        self.img = CityDetailObject.handleStringToArray(jsonStr: json["img"] as? String ?? "")
        
        self.imgTitle = json["imgtitle"] as? String ?? ""
        self.content = json["content"] as? String ?? ""
        self.summary = json["summary"] as? String ?? ""
        
        let poiArray = CityDetailObject.handleStringToArray(jsonStr: json["poi"] as? String ?? "")
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

        self.youtube = CityDetailObject.handleTheYoutubeJson(jsonStr: json["youtube"] as? String ?? "")

        self.guideMap = CityDetailObject.handleStringToArray(jsonStr: json["guidemap"] as? String ?? "")
        self.storyImg = json["storyimg"] as? String ?? ""
        
        
    }
    
    /**
     It's to transfer the json's back data like string but we want it to array.
     - Parameter jsonStr: Json back data.
     - Returns: Transfer to array
     */
    private static func handleStringToArray(jsonStr: String) -> [String] {
        
        guard let jsonData = jsonStr.data(using: .utf8) else {return [""] }
        var strArray: [String]?
        
        do{
            strArray = [String]()
            
            strArray = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String]
            
            
        }catch let jsonError{
            
            print("Poi is nil :\(jsonError.localizedDescription)")
            
        }
        
        guard let finalStrArray = strArray else {
            print("Array is nil")
            return [""] }
        
        return finalStrArray
        
    }
    
    
    func toString(){
        print("\(self.name),\(self.guideMap)")
    }
    
    
    private static func handleTheYoutubeJson(jsonStr: String) -> [String]{
        
        guard let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false) else {return ["1"] }
        var strArray: [[String: Any]]?
        
        do{
            strArray = [[String: Any]]()
            
            strArray = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [[String: Any]]
            
            
        }catch let jsonError{
            
            print("YoutubeJson is nil :\(jsonError.localizedDescription)")
            
        }
        
        guard let finalStrArray = strArray else {
            print("Array is nil")
            return ["2"] }
        
        var finalYoutubeArray = [String]()
        for i in finalStrArray{
            let id = i["id"] as? String ?? ""
            let type = i["type"] as? String ?? ""
            print("ID: \(id) and type: \(type)")
            finalYoutubeArray.append(id)
            
        }
        
        
        return finalYoutubeArray
        
        
    }
    
}
