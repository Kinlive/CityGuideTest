//
//  CityListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/2.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation
struct CityListModel{
    
    private static var shared: CityListModel = {

        let standard = CityListModel(cityList: [])

        print("初始化 cityList singleton")
        return standard
    }()

     static func standard() -> CityListModel{

        print("拿到singleton")

        return shared
    }
    
    
    
    
    var cityList: [City]
   
    
    func toString(){

        for city in cityList{
            print(city.name)
            print(city.id)
            print(city.number)
        }
        
    }
    
}

///City struct

struct City{
    let number: String
    let name: String
    let id: String
    
    init(json: [String: Any]){
        self.number = json["no"] as? String ?? ""
        self.id = json["id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
    }
    
}

