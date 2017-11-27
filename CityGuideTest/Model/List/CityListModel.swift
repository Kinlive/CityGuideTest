//
//  CityListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/2.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

 ///Save City's name、id、number struct.
struct CityListModel{
    
    
     ///CityListModel's singleton.
    private static var shared: CityListModel = {

        let standard = CityListModel(cityList: [])

        return standard
    }()
    
    ///Get CityListModel standard singleton.
     static func standard() -> CityListModel{

        return shared
    }
    
    
    
    ///Save every struct of City.
    var cityList: [City]
   
    ///Print all City's properties.
    func toString(){

//        for city in cityList{
//            print(city.name)
//            print(city.id)
//            print(city.number)
//        }
        
    }
    
}


 ///To save number & name & id.
struct City{
    ///City no.
    let number: String
    ///City name.
    let name: String
    ///City id.
    let id: String
    
    let img: [String]
    
    /**
     Initialize the City of Struct when json parse.
     - Parameter json: From the server back data.
     */
    init(json: [String: Any]){
        self.number = json["no"] as? String ?? ""
        self.id = json["id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.img = City.handleStringToArray(jsonStr: json["img"] as? String ?? "")
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

