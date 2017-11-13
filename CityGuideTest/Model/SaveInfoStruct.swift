//
//  SaveInfoStruct.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/6.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation



///Save some infomation when user select api.
struct SaveInfoStruct{
    
    private static var shared: SaveInfoStruct = {
        
        let standard = SaveInfoStruct()
        
        return standard
    }()
    
    ///Get SaveInfoStruct's singleton.
    static func standard() -> SaveInfoStruct{
        
        return shared
    }
    
    //MARK: - ===SaveInfoStruct properties===
    ///Save which api select of Enum's WhichAPIGet.
    private var whichSelected: WhichAPIGet?
    
    ///Save for get TypeListCell's name when cell be selected.
    var whichUrlStr: String?
    
    ///Save for currently segmentedControl's title.
    private var whichSegmentedTitle: SegmentedTitle?
    
    ///Save for which subSortCell be selected.
    private var selectedIndexOfSubCell: IndexPath?
    
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
    /**
     SaveInfoStruct.segmentTitle set func.
     - Parameter segmentTitle: Which segmentTitle be set.
     */
    mutating func setWhich(segmentTitle: SegmentedTitle){
        
        self.whichSegmentedTitle = segmentTitle
     
    }
    
    /**
     SaveInfoStruct.segmentTitle get func.
     - Returns: SaveInfoStruct.whichSegmentedTitle.
     */
    func getWhichSegmentedTitle() -> SegmentedTitle?{
        guard let segmentedTitle = whichSegmentedTitle else {
            print("Segment 切換時 都給nil")
            return nil }
        
        return segmentedTitle
        
    }
    
    
    
    
    //MARK: - Property *whichSelected* API get&set func
    /**
     SaveInfoStruct.whichSelected set func.
     - Parameter selectedAPI: Which api be set.
     */
    mutating func setWhich(selectedAPI: WhichAPIGet){
        
        self.whichSelected = selectedAPI
        
    }
    
    /**
     SaveInfoStruct.whichSelected get func.
     - Returns: SaveInfoStruct.whichSelected.
     */
    func getWhichSelectedAPI() -> WhichAPIGet?{
        
        guard let whichSelectedAPI = whichSelected else { return nil }
        
        return whichSelectedAPI
    }

    
    //MARK: - Prepare for selectedIndexWithSubCell set&get.
    mutating func setWhichSelected(indexPath: IndexPath){
        self.selectedIndexOfSubCell = indexPath
    }
    
    func getSelectedIndexPath() -> IndexPath?{
        
        guard let selectedIndexPath = self.selectedIndexOfSubCell else {
            return nil
        }
        
        return selectedIndexPath
    }

}

