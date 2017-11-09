//
//  SaveInfoStruct.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/6.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation




struct SaveInfoStruct{
    
    private static var shared: SaveInfoStruct = {
        
        let standard = SaveInfoStruct()
        
        //        print("初始化 cityList singleton")
        return standard
    }()
    
    static func standard() -> SaveInfoStruct{
        
        //        print("拿到singleton")
        
        return shared
    }
    
    
    
    private var whichSelected: WhichAPIGet?
    
    var whichUrlStr: String?
    
    private var whichSegmentedTitle: SegmentedTitle?
    
    
//    var testForGet: String{
//        get{
//            return "forGET 556+\(self.testForGet)"
//        }
//        set(newString){
//            self.testForGet = "FOR SET 321\(newString)"
//        }
//        
//    }
    
    
    //MARK: - Property *whichSegmentedTitle* API get&set func
    mutating func setWhich(segmentTitle: SegmentedTitle){
        
        self.whichSegmentedTitle = segmentTitle
     
    }
    
    
    func getWhichSegmentedTitle() -> SegmentedTitle?{
        guard let segmentedTitle = whichSegmentedTitle else {
            print("Segment 切換時 都給nil")
            return nil }
        
        return segmentedTitle
        
    }
    
    
    
    
    //MARK: - Property *whichSelected* API get&set func
    mutating func setWhich(selectedAPI: WhichAPIGet){
        
        self.whichSelected = selectedAPI
        
    }
    
    func getWhichSelectedAPI() -> WhichAPIGet?{
        
        guard let whichSelectedAPI = whichSelected else { return nil }
        
        return whichSelectedAPI
    }


}

