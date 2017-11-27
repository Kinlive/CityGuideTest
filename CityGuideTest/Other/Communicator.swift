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
            print("NO url")
            return}
        print("URLURLURLURLURL:\(url)")
        //Check for which api get .
        if let whichApiGet = whichApiGet { //Get json api
            
//            if whichApiGet != .searchKeyword{ //Normal api request
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
//            }else if whichApiGet == .searchKeyword{
//
//
//            }
           
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
            
            guard let finalJson = json as? [[String: Any]] else { return }
            
            //Put on which model
            switch  whichAPI {
                
            case .cityList:
              
                handleCityList(json: finalJson, completion: completion)
            
            case .typeList:
                handleTypeList(json: finalJson, completion: completion)
                
            case .brandList:
                 handleBrandList(json: finalJson, completion: completion)
            
            case .cityDetail:
              
                handleCityDetailList(json: finalJson, completion: completion)
            
            case .typeDetail:
                
                handleTypeDetailList(json: finalJson, completion: completion)
            
            case .brandDetail:
             
                handleBrandDetailList(json: finalJson, completion: completion)
            
            case .downloadImg:
                print("On saveDataOnModel doloadImg case.")
                
                handleTopPlaceList(json: finalJson, completion: completion)
            
            case .searchKeyword:
                
                handleSearchResultList(json: finalJson, completion: completion)
                print("On saveDataOnModel searchKeyword.")
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
        //For cache data
//        let forCacheObject = brandDetailListModel.brandDetailList
        
//        cacheObjectData.setObject(forCacheObject as AnyObject,
//                                  forKey: saveInfoStruct.whichUrlStr as AnyObject )
        
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
        
        //For cache data
//        let forCacheObject = cityDetailListModel.cityDetailList
        
//        cacheObjectData.setObject(forCacheObject as AnyObject,
//                                  forKey: saveInfoStruct.whichUrlStr as AnyObject )
        
        
        completion(true)
        
    }
    
    func downloadTheImage(completion: @escaping HandleCompletion){
        
        
        for topPlace in topPlaceResultModel.topPlaceResultList{
            
            let imgName = topPlace.img.first ?? "noImg"
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
    
}



