//
//  GuideMapModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/12/1.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

///Save GuideMapModel struct.
struct GuideMapModel{
    
    ///GuideMapModel singleton.
    private static var shared: GuideMapModel = {
        
        let standard = GuideMapModel(guideMapObjectList: [:])
        
        return standard
    }()
    
    ///Get CityDetailListModel standard singleton.
    static func standard() -> GuideMapModel{
        
        return shared
    }
    
    
    
    ///Save every struct of CityDetail.
    var guideMapObjectList: [String:GuideMapObject]
    
    
    func toString(){
        
        print("總數：\(guideMapObjectList.count)")
        
        //        for cityDetail in cityDetailList{
        //            print(cityDetail.name)
        //            print(cityDetail.id)
        //            print(cityDetail.number)
        //        }
        
        
    }
    
}

///Save every detail infomation,it most detail to look on  http://bit.ly/2hX6sI7
struct GuideMapObject{
    
    let title: String
    let img: String
    var location: [Location] = []
    
    init(json: [String: Any]){
        
        self.title = json["title"] as? String ?? ""
        self.img = json["img"] as? String  ?? ""
        
        if let locations = json["location"] as? [[String:Any]] {
            
            for locOne in locations{
             
                let locObject = Location.init(json: locOne)
                self.location.append(locObject)
            }
        }
        
//        self.location = json["location"] as! [GuideMapObject.Location]
        
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
    
//
//    func toString(){
//        print("\(self.name),\(self.guideMap)")
//    }
//
    
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

struct Location{
    let id: String
    let latitude: String
    let longitude: String
    let heading: String
    let pitch: String
    let zoom: Float
    let x: Double
    let y: Double
    
    init (json: [String:Any]){
        
        self.id = json["id"] as? String ?? ""
        self.latitude = json["latitude"] as? String ?? ""
        
        var lonStr = json["longitude"] as? String ?? ""
        if lonStr.contains(" "){
            lonStr.remove(at: lonStr.index(of: " ")!)
//            self.longitude = lonStr
            
        }
        self.longitude = lonStr
        
        self.heading = json["heading"] as? String ?? ""
        self.pitch = json["pitch"] as? String ?? ""
        self.zoom = json["zoom"] as? Float ?? 1
        self.x = json["x"] as? Double ?? 0.0
        self.y = json["y"] as? Double ?? 0.0
        
    }
    
    
    func parseTheStringOrDouble(str: String,json: [String: Any]){
        if str == ""{
         
            
        }
    }
    
    
}
