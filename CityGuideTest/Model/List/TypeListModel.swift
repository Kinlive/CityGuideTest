//
//  TypeListModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/2.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation
///Save Type's name、id、number struct.
struct TypeListModel{
    
    ///TypeListModel's singleton.
    private static var shared: TypeListModel = {
        
        let standard = TypeListModel(typeList: [])
        
        return standard
    }()
    
    ///Get TypeListModel standard singleton.
    static func standard() -> TypeListModel{
        
        return shared
    }
    
    
    
    ///Save every object of Type.
    var typeList: [Type]
    
    ///Print all Type's properties.
    func toString(){
        
        
//        for type in typeList{
//            print(type.name)
////            print(type.id)
//            print(type.number)
//        }
//
        
    }
    
}


///To save number & name & id.
struct Type{
    ///Type no.
    let number: String
    ///Type name.
    let name: String
    let id: String
    let img: [String]
    
    /**
     Initialize the Type of Struct when json parse.
     - Parameter json: From the server back data.
     */
    init(json: [String: Any]){
        self.number = json["no"] as? String ?? ""
        self.id = json["img"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.img = Type.handleStringToArray(jsonStr: json["img"] as? String ?? "")
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
