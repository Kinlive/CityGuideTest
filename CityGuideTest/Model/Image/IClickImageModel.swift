//
//  iClickImageModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/8.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class IClickImageModel: NSObject{
    
    private static var standardImageModel: IClickImageModel = {
        
        let standard = IClickImageModel()
        
        //        print("初始化 imageModel singleton")
        return standard
    }()
    
    class func standard() -> IClickImageModel{
        
        //        print("拿到singleton")
        
        return standardImageModel
    }
    
    
    var image: UIImage?
    
    typealias HandleCompletion = ( _ success: Bool) -> Void
    func handleImageWith(data: Data , completion: HandleCompletion){
        
        if let image = UIImage(data: data){
            
            self.image = image
            
            completion(true)
        }else {
            
            
            print("No image \(data.description)")
            completion(false)
        }
    }
    
    
    
    
}
