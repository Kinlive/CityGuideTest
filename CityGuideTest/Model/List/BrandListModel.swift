//
//  BrandListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/3.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

///Save Brand's name、id、number struct.
struct BrandListModel{
    
    ///BrandListModel's singleton.
    private static var shared: BrandListModel = {
        
        let standard = BrandListModel(brandList: [])
        
        return standard
    }()
    
    ///Get BrandListModel standard singleton.
    static func standard() -> BrandListModel{
        
        return shared
    }
    
    
    
    ///Save every struct of City.
    var brandList: [Brand]
    
    ///Print all Brand's properties.
    func toString(){
        
        for brand in brandList{
            print(brand.name)
            print(brand.id)
            print(brand.number)
        }
        
        
    }
    
}

///To save number & name & id.
struct Brand{
    ///Brand no.
    let number: String
    ///Brand name.
    let name: String
    ///Brand id.
    let id: String
    
    /**
     Initialize the Brand of Struct when json parse.
     - Parameter json: From the server back data.
     */
    init(json: [String: Any]){
        self.number = json["no"] as? String ?? ""
        self.id = json["id"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
    }
    
}
