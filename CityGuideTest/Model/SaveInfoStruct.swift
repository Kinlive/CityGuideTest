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
    

    private var mapTitle: String?
    private var mapAddress: String?
    private var mapCoordinate = [Float]()
    
    var mapPanoUrl: String?
    var guideMapImageName: [String] = []
    var saveGuideMapNameForObject: String?
    
    var youtubeID: [String] = []
    
    ///It's for check now is search request or not.
    var isSearchNow: CheckIsSearch = .noSearch
    ///Search keyword save
    var keywordOfSearch: String?
    
    ///GuideMap download save.
    var guideMapNames: [String] = []
    
    
    mutating func saveInfoOfMap(title: String, address: String, coordinate:[Float]){
        self.mapTitle = title
        self.mapAddress = address
        self.mapCoordinate = coordinate
        
    }
    
    func getMapNeedsData() -> (String?, String?,[Float]) {
        
        let mapData = (mapTitle, mapAddress, mapCoordinate)
        
        return mapData
    }
    
    mutating func resetMapData(){
        
        self.mapTitle = nil
        self.mapAddress = nil
        self.mapCoordinate.removeAll()
        self.mapCoordinate = [Float]()
    }
    
    
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


//    var testForGet: String{
//        get{
//            return "forGET 556+\(self.testForGet)"
//        }
//        set(newString){
//            self.testForGet = "FOR SET 321\(newString)"
//        }
//
//    }
