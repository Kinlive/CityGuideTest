//
//  PanoramaModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/30.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

///Save PanoramaModel struct.
struct PanoramaModel{
    
    ///PanoramaModel's singleton.
    private static var shared: PanoramaModel = {
        
        let standard = PanoramaModel(panoramaObjectList: [])
        
        return standard
    }()
    
    ///Get PanoramaModel standard singleton.
    static func standard() -> PanoramaModel{
        
        return shared
    }
    
    
    
    ///Save every struct of PanoramaObjectList.
    var panoramaObjectList: [PanoramaObject]
    
    
    func toString(){
        
        print("總數：\(panoramaObjectList.count)")
    }
    
}

///Save every detail infomation,it most detail to look on  http://bit.ly/2hX6sI7
struct PanoramaObject{
    let panoId: String
    let position: String
    let lat: String
    let lon: String
    let heading: String
    let pitch: Double
    let zoom: String
    
    init(json: [String: Any]){
        self.panoId = json["id"] as? String ?? ""
        self.position = json["position"] as? String ?? ""
        self.lat = json["latitude"] as? String ?? ""
        self.lon = json["longitude"] as? String ?? ""
        
        self.heading =  json["heading"] as? String ?? ""
        
        self.pitch = json["pitch"] as? Double ?? 0.0
        self.zoom = json["zoom"] as? String ?? ""
       
    }
    
    func toString(){
        print("id:\(self.panoId),position:\(self.position),lat:\(lat),lon:\(lon),heading:\(heading),pitch:\(pitch),zoom:\(zoom)。")
        
        
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
