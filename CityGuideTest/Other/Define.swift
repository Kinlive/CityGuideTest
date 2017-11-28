//
//  Define.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/1.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

///Main url
let ICLICK_URL = "http://www.viewtaiwan.com/"

///Get City number list "vtapp/getdata.php?dbname=city"
let GET_CITYLIST_URL = "vtapp/getdata.php?dbname=city"
///Get Brand number list getBrandListl.php
let GET_BRANDLIST_URL = "vtapp/getdata.php?dbname=brand"
///Get Tag of Type number list , it can be find with chinese getTagList.php
let GET_TYPELIST_URL = "vtapp/getdata.php?dbname=tag"

///API: Request for Brands ,old api:getPanoValueBrand.php?brand=
let GET_PANOBRAND_URL = "vtapp/getdata.php?dbname=place&order=votes&desc=true&brand="
///API: Request for City ,old api: getPanoValueCity.php?city=  vtapp/getdata.php?dbname=place&city=
let GET_PANOCITY_URL = "vtapp/getdata.php?dbname=place&order=votes&desc=true&city="
///API: Request for Tag of type ,old api:getPanoValueTag.php?tag=
let GET_PANOTAG_URL = "vtapp/getdata.php?dbname=place&order=votes&desc=true&tag="

///API: Request for download the image, contain guideMap
let GET_PLACEIMG_URL = "upload/place/"
///API: Request for download image of City.
let GET_CITYIMG_URL = "upload/city/"
///API: Request for download image of Tag.
let GET_TAGIMG_URL = "upload/tag/"
///API: Request for download image of Brand.
let GET_BRANDIMG_URL = "upload/brand/"

///API: Request for search keyword.
let GET_SEARCH_URL = "vtapp/getdata.php?dbname=place&name="

///API: Request for hot place.
let GET_HOTPLACE_URL = "vtapp/getdata.php?dbname=place&order=votes&desc=true&limit=5"

///API: Request for get guidemap
//let GET_GUIDEMAP_URL = "upload/guidemap/"


///Identify here
let typeListTableViewCellId = "typeListCell"

let subSortTableViewCellId = "SubSortTableViewCell"

let SEARCHRESULTCELL_ID = "SearchResultTableViewCell"//no use

///GoogleMap API key
//let GMSAPI_Key = "AIzaSyCaBlL_1-qcmOtcKUMTmjRRPJ2jFqdxA9c"
let GMSAPI_Key2 = "AIzaSyCsBLVDhdaSm_bzE8U1vSYiRhG2sW9m7U4"



