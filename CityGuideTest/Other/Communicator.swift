//
//  Communicator.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/2.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import Foundation

class Communicator: NSObject{
    
    let sessionShared = URLSession.shared
    
    
    
    
    
    typealias HandleCompletion = ( _ success: Bool) -> Void
    func connectToService(urlStr: String, whichApiGet: WhichAPIGet? , completion:  @escaping HandleCompletion){
        
        
        
        guard let url = URL(string: urlStr.urlEncoded()) else {
            print("NO url")
            return}
        
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
                    
//                    if let data = try? Data(contentsOf:url!){
//
//                        standardiClickImage.handleImageWith(data: data,
//                                                            completion: { (success) in
//                            if success{
                        
                                //download success
                                completion(true)
                            
//                            }
//                        })
//                    }
                }
            })
            
            downloadTask.resume()
        }
    }
    
    fileprivate func downloadImageWith(data: Data,completion: HandleCompletion){
        
        
        
        
    }
    
    
    
    //MARK: - saveDataOnModel func
    /**
     Handle the json object and switch which api pass in ,then jump to next func.
     
     - Parameter data: **Data**, Mean the before func's task response's data
     - Parameter whichAPI: **Enum**, User select which segment and which cells , it will be change.
     - Parameter completion: **typealias**, HandleCompletion when did end.
     */
    fileprivate func saveDataOnModel(data: Data ,whichAPI: WhichAPIGet , completion: HandleCompletion ){
        
        do{
            
            let json = try JSONSerialization.jsonObject(with: data,
                                                        options: .mutableContainers)
  
            switch  whichAPI {
                
            case .cityList:
              
                guard let finalJson = json as? [[String: Any]] else { return }
                
                handleCityList(json: finalJson, completion: completion)
            
            case .typeList:
                
                guard let finalJson = json as? [[String: Any]] else {return}
                
                handleTypeList(json: finalJson, completion: completion)
                
            
            case .brandList:
                
                guard let finalJson = json as? [[String: Any]] else {return }
                handleBrandList(json: finalJson, completion: completion)
            
            case .cityDetail:
                print("CityDetail")
                guard let finalJson = json as? [[String : Any ]] else { return }
                handleCityDetailList(json: finalJson, completion: completion)
            
            case .typeDetail:
                print("TypeDetail")
                
                guard let finalJson = json as? [[String: Any]] else {return }
                
                handleTypeDetailList(json: finalJson, completion: completion)
            
            case .brandDetail:
                print("BrandDetail")
                
                guard let finalJson = json as? [[String: Any]] else {return }
                handleBrandDetailList(json: finalJson, completion: completion)
            
            }
        
            
            
        }catch let jsonErr{
            print("error parser:\(jsonErr.localizedDescription)")
        }
    }
    
    
    
    //MARK: - handleCityList func
    fileprivate func handleCityList(json: [[String: Any]] , completion: HandleCompletion){
        
        for cityOne in json{
            
            let city = City.init(json: cityOne)
            
            cityListModel.cityList.append(city)
            
        }
        
        completion(true)
        
    }
    
    
    //MARK: - handleTypeList func
    fileprivate func handleTypeList(json: [[String: Any]], completion: HandleCompletion){
        
        for typeOne in json{
            
            let type = Type.init(json: typeOne)
            
            //Avoid database give empty value
            if type.name == "" || type.number == ""{
                
//                print("name:\(type.name), number:\(type.number)")
            }else{
                
                typeListModel.typeList.append(type)
            }
            
        }
        
        completion(true)
    }
    
    
    //MARK: - handleBrandList func
    fileprivate func handleBrandList(json: [[String:Any]], completion: HandleCompletion){
        
        for brandOne in json{
            
            let brand = Brand.init(json: brandOne)
            
            //Avoid database give empty value
            if brand.name == "" || brand.number == "" || brand.id == "" {
                
//                print("name:\(brand.name), number:\(brand.number)")
            }else{
                
                brandListModel.brandList.append(brand)
            }
            
        }
        
        completion(true)
        
    }
    
    //MARK: - handelCityDetailList func
    fileprivate func handleCityDetailList(json: [[String: Any]], completion: HandleCompletion){
        
        cityDetailListModel.cityDetailList.removeAll()
        
        for (_,cityDetailOne) in json.enumerated() {
            

            let cityDetail = CityDetailObject.init(json: cityDetailOne)
            
            cityDetailListModel.cityDetailList.append(cityDetail)
            
        }
        
        completion(true)
        
    }
    
    //MARK: - HandleTypeDetailList func
    fileprivate func handleTypeDetailList(json: [[String: Any]], completion: HandleCompletion){
        
        typeDetailListModel.typeDetailList.removeAll()
        
        for typeDetailOne in json {
            
            let typeDetail = TypeDetailObject.init(json: typeDetailOne)
            
            typeDetailListModel.typeDetailList.append(typeDetail)
        }
        
        
        completion(true)
    }
    
    //MARK: - HandleBrandDetailList func
    fileprivate func handleBrandDetailList(json: [[String: Any]], completion: HandleCompletion){
        
        brandDetailListModel.brandDetailList.removeAll()
        
        for brandDetailOne in json {
            
            let brandDetail = BrandDetailObject.init(json: brandDetailOne)
            
            brandDetailListModel.brandDetailList.append(brandDetail)
        }
        
        completion(true)
    }
    
    
   
    
    
}



