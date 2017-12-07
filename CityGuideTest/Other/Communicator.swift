//
//  Communicator.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/2.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

///To communicate between app to server that get data from database.
class Communicator: NSObject{
    
    let sessionShared = URLSession.shared

    let topOperationQueue = OperationQueue()
    
    typealias HandleCompletion = ( _ success: Bool) -> Void
    /**
     Request to server.
     - Parameter urlStr: Connect url.
     - Parameter whichApiGet: For switch request with which api.
     - Parameter completion: When request did end.
     */
    func connectToServer(urlStr: String, whichApiGet: WhichAPIGet? , completion:  @escaping HandleCompletion){
        
        //Check for url string.
        guard let url = URL(string: urlStr.urlEncoded()) else {
            print("NO url:\(urlStr)")
            return}
        print("URLURLURLURLURL:\(url)")
        
        //Check for which api get .
        if let whichApiGet = whichApiGet { //Get json api
            
            let task = sessionShared.dataTask(with: url) { (data, response, error) in
                    
                if let error = error {
                        
                    print(error.localizedDescription)
                        
                    return
                }
                    
                guard let data = data else {
                        
                    print("No data")
                        
                    return }
                    
                self.saveDataOnModel(data: data,
                                         whichAPI: whichApiGet,
                                         completion: completion)
            }
                
            task.resume()

        }else{ // Into the download images api
                
            let downloadTask = sessionShared.downloadTask(with: url, completionHandler: { (url, response, error) in
              
                if let error = error {
                    
                    print("\(error.localizedDescription)")
                
                }else{
 
                    completion(true)

                }
            })
            
            downloadTask.resume()
        }
    }
    

    
    //MARK: - saveDataOnModel func
    /**
     Handle the json object and switch which api pass in ,then jump to next func.
     
     - Parameter data: **Data**, Mean the before func's task response's data
     - Parameter whichAPI: **Enum**, User select which segment and which cells , it will be change.
     - Parameter completion: **typealias**, HandleCompletion when did end.
     */
    fileprivate func saveDataOnModel(data: Data ,whichAPI: WhichAPIGet , completion: HandleCompletion ){
        
        do{//JSON parse.
            
            
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: .mutableContainers)
            
//            guard let finalJson = json as? [[String: Any]] else { return }
            
            //Put on which model
            switch  whichAPI {
                
            case .cityList:
              
                guard let finalJson = json as? [[String: Any]] else { return }
                handleCityList(json: finalJson, completion: completion)
            
            case .typeList:
                guard let finalJson = json as? [[String: Any]] else { return }
                handleTypeList(json: finalJson, completion: completion)
                
            case .brandList:
                 guard let finalJson = json as? [[String: Any]] else { return }
                 handleBrandList(json: finalJson, completion: completion)
            
            case .cityDetail:
              
                guard let finalJson = json as? [[String: Any]] else { return }
                handleCityDetailList(json: finalJson, completion: completion)
            
            case .typeDetail:
                
                guard let finalJson = json as? [[String: Any]] else { return }
                handleTypeDetailList(json: finalJson, completion: completion)
            
            case .brandDetail:
             
                guard let finalJson = json as? [[String: Any]] else { return }
                handleBrandDetailList(json: finalJson, completion: completion)
            
            case .downloadImg:
                
                guard let finalJson = json as? [[String: Any]] else { return }
                handleTopPlaceList(json: finalJson, completion: completion)
            
            case .searchKeyword:
                
                guard let finalJson = json as? [[String: Any]] else { return }
                handleSearchResultList(json: finalJson, completion: completion)
                
            case .panoramaObject:
                
                guard let finalJson = json as? [String: Any] else { return }
                
                handlePanoramaData(json: finalJson, completion: completion)
                
            case .guideMapObject:
                guard let finalJson = json as? [String: Any] else { return }
                handleGuideMapData(json: finalJson, completion: completion)
                
            }
        
        }catch let jsonErr{
            print("error parser:\(jsonErr.localizedDescription)")
        }
    }
    
    
    
    //MARK: - handleCityList func
    /**
     Handle the cityList data on struct.
     - Parameter json: Array of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handleCityList(json: [[String: Any]] , completion: HandleCompletion){
        
        for cityOne in json{
            
            let city = City.init(json: cityOne)
            
            cityListModel.cityList.append(city)
            
        }
        
        completion(true)
        
    }
    
    
    //MARK: - handleTypeList func
    /**
     Handle the typeList data on struct.
     - Parameter json: Array of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handleTypeList(json: [[String: Any]], completion: HandleCompletion){
        
        for typeOne in json{
            
            let type = Type.init(json: typeOne)
            
            //Avoid database give empty value
            if type.name == "" || type.number == ""{
                
            }else{
                
                typeListModel.typeList.append(type)
            }
            
        }
        
        completion(true)
    }
    
    
    //MARK: - handleBrandList func
    /**
     Handle the brandList data on struct.
     - Parameter json: Array of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handleBrandList(json: [[String:Any]], completion: HandleCompletion){
        
        for brandOne in json{
            
            let brand = Brand.init(json: brandOne)
            
            //Avoid database give empty value
            if brand.name == "" || brand.number == "" || brand.id == "" {
                
            }else{
                
                brandListModel.brandList.append(brand)
            }
            
        }
        
        completion(true)
        
    }
    
    //MARK: - handelCityDetailList func
    /**
     Handle the cityDetail data on struct.
     - Parameter json: Array of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handleCityDetailList(json: [[String: Any]], completion: HandleCompletion){
        
        cityDetailListModel.cityDetailList.removeAll()
        
        for (_,cityDetailOne) in json.enumerated() {
            

            let cityDetail = CityDetailObject.init(json: cityDetailOne)
            
            cityDetailListModel.cityDetailList.append(cityDetail)
            
        }
        
        //For cache data
        let forCacheObject = cityDetailListModel.cityDetailList
        
        cacheObjectData.setObject(forCacheObject as AnyObject,
                                  forKey: saveInfoStruct.whichUrlStr as AnyObject )
        
        
        completion(true)
        
    }
    
    //MARK: - HandleTypeDetailList func
    /**
     Handle the typeDetail data on struct.
     - Parameter json: Array of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handleTypeDetailList(json: [[String: Any]], completion: HandleCompletion){
        
        typeDetailListModel.typeDetailList.removeAll()
        
        for typeDetailOne in json {
            
            let typeDetail = TypeDetailObject.init(json: typeDetailOne)
            
            typeDetailListModel.typeDetailList.append(typeDetail)
        }
        
        //For cache data
        let forCacheObject = typeDetailListModel.typeDetailList
        
        cacheObjectData.setObject(forCacheObject as AnyObject,
                                  forKey: saveInfoStruct.whichUrlStr as AnyObject )
        
        
        completion(true)
    }
    
    //MARK: - HandleBrandDetailList func
    /**
     Handle the brandDetail data on struct.
     - Parameter json: Array of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handleBrandDetailList(json: [[String: Any]], completion: HandleCompletion){
        
        brandDetailListModel.brandDetailList.removeAll()
        
        for brandDetailOne in json {
            
            let brandDetail = BrandDetailObject.init(json: brandDetailOne)
            
            brandDetailListModel.brandDetailList.append(brandDetail)
        }
        //For cache data
        let forCacheObject = brandDetailListModel.brandDetailList
        
        cacheObjectData.setObject(forCacheObject as AnyObject,
                                  forKey: saveInfoStruct.whichUrlStr as AnyObject )
        
        completion(true)
    }
    
    //MARK: - HandleSearchResultList func
    /**
     Handle the searchResult data on struct.
     - Parameter json: Array of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handleSearchResultList(json: [[String: Any]], completion: HandleCompletion){
        
        searchResultModel.searchResultList.removeAll()
        
        for searchResultOne in json {
            
            let searchResult = SearchResultObject.init(json: searchResultOne)
            
            searchResultModel.searchResultList.append(searchResult)
        }
       
        completion(true)
    }
   
    
    //MARK: - handleTopPlaceList func
    /**
     Handle the topPlace data on struct.
     - Parameter json: Array of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handleTopPlaceList(json: [[String: Any]], completion: HandleCompletion){
        
        topPlaceResultModel.topPlaceResultList.removeAll()
        
        for (_,topPlaceResultOne) in json.enumerated() {
            
            
            let topPlace = TopPlaceResultObject.init(json: topPlaceResultOne)
            
            topPlaceResultModel.topPlaceResultList.append(topPlace)
            
        }
        
        completion(true)
        
    }
    
    
    //MARK: - handleGuideMapData func
    /**
     Handle the guideMap data on struct.
     - Parameter json: Array of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handleGuideMapData(json: [String: Any], completion: HandleCompletion){
        
//        guideMapModel.guideMapObjectList.removeAll()

//        print("Test for the guideName[] : \(saveInfoStruct.guideMapNames)")
        
        for (_,imgName) in saveInfoStruct.guideMapNames.enumerated(){
            if
                let guideMapObject = json[imgName] as? [String: Any] {
                //            saveInfoStruct.guideMapNames.removeFirst()
//                print("Test for guideMapObject pase的結果============ \(guideMapObject)")
                let guideMap = GuideMapObject.init(json: guideMapObject)
//                print("guideMapObject  init 的結果[][][][]:\(guideMap)")
                guideMapModel.guideMapObjectList[imgName] = guideMap
                completion(true)
            }else{
                
//                print("Parse guideMapObject fail. Maybe the key name incorrect.")
                completion(false)
            }
        }
    }
    
    
    //MARK: - downloadTheImage
    /**
     Download the top place's img ,
     */
    func downloadTheImage(completion: @escaping HandleCompletion){
        
        
        for topPlace in topPlaceResultModel.topPlaceResultList{
            
            let imgName = topPlace.img.first ?? "noImg"
//            let imgId = topPlace.id
            let urlStr = "\(ICLICK_URL)\(GET_PLACEIMG_URL)\(imgName)"
//            topOperationQueue.addOperation {
            guard let url = URL(string: urlStr.urlEncoded()) else {
                print("NO url")
                return}
            
                let downloadTask = sessionShared.downloadTask(with: url, completionHandler: { (url, response, error) in
                    if let err = error {
                       print("\(err.localizedDescription)")
                    }else{
                        
                        
                        
                     completion(true)
                        
                    }
                })
                downloadTask.resume()
            
        }
    }
    
    //MARK: - handlePanoramaData func
    /**
     Handle the panorama data on struct.
     - Parameter json: Dictionary of parse end.
     - Parameter completion: Handle completion.
     */
    fileprivate func handlePanoramaData(json: [String: Any], completion: HandleCompletion){
        
        panoramaModel.panoramaObjectList.removeAll()
        
        print("Test for the json by panorama data=========: \(json)")
        let panoramaOne = PanoramaObject.init(json: json)
            
        panoramaModel.panoramaObjectList.append(panoramaOne)
        
        panoramaOne.toString()
        completion(true)
    }
    
}



