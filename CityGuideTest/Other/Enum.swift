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
 ````
 case cities
 case types
 case brands
 ````
 */
enum SegmentedTitle: String {
    
    ///Now was city selected on segmented title,and will do something about city.
    case cities
    ///Now was type selected on segmented title,and will do something about type.
    case types
    ///Now was brand selected on segmented title,and will do something about brand.
    case brands
}

/**
 Define for choice which api to get.
 ````
 case cityList
 case typeList
 case brandList
 case cityDetail
 case typeDetail
 case brandDetail
 ````
 */
enum WhichAPIGet{
    
    ///Which api get when any cells be selected.
    case cityList //For main viewController get cityName,number to show on tableView.
    
    case typeList
    
    case brandList
    
    case cityDetail
    
    case typeDetail
    
    case brandDetail
    
    case downloadImg
    
    case searchKeyword
    
    
}


enum CheckIsSearch: Int{
    
    case noSearch = 0
    
    case isSearch
}

