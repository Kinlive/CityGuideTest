//
//  ImageDataModel.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/1.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class ImageDataModel: NSObject{
    
    private static var standardImageModel: ImageDataModel = {
       
        let standard = ImageDataModel()
        
//        print("初始化 imageModel singleton")
        return standard
    }()
    
    class func standard() -> ImageDataModel{
        
//        print("拿到singleton")
        
        return standardImageModel
    }
    
    private var images: [UIImage]?
    
    private var imagesName: [String]?
    
    
    /**
     Put all imageNames in string array, it will set on this class's property **imagesName** and handle on a **images array**
     - Parameter names: All Your image name ,please give array.
     */
    open func handleAllImage(names: [String]){
        
        self.imagesName = names
        
        guard let imagesName = imagesName else {
            print("沒有拿到圖片名稱")
            return }
        
        for name in imagesName{
            
            guard let image = UIImage(named:"\(name)") else { return }
            
            images?.append(image)
            print("圖片順利加入陣列")
            
        }
    }
    
//    open func setImagesName(names: [String]){
//        self.imagesName = names
//
//
//    }
    
    
    /**
     If it's ready on *func handleAllImage()*,that can get all images on this method.
     - Returns: This will return Image's array
     */
    open func getAllImages() -> [UIImage]?{
        
        guard let images = images else {
            print("沒有拿到圖片")
            return nil}
        
        print("順利拿到圖片")
        return images
        
    }
    
    
    
}
