//
//  Enum.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/1.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation


/**
 Define for which segmentedTitle be selected.
 */
enum SegmentedTitle: String {
    case cities, types, brands
}

/**
 Define for choice which api to get.
 */
enum WhichAPIGet{
    
    
    case cityList //For main viewController get cityName,number to show on tableView.
    
    case typeList
    
    case brandList
    
    case cityDetail
    
    case typeDetail
    
    case brandDetail
    
    
    
}

//struct SaveWhichAPIGet {
//     var whichSelect: WhichAPIGet
//}

