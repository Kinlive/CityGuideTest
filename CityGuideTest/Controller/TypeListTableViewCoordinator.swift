//
//  TypeListTableViewCoordinator.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/10/31.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit
/**
 The coordinator is bridge between SecondViewController and typeListTableView.
 */
class TypeListTableViewCoordinator: NSObject ,UITableViewDelegate,UITableViewDataSource{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        guard let segmentTitle = saveInfoStruct.getWhichSegmentedTitle() else {
            print("第一次圖取時")
            
            return 0}
        
        switch segmentTitle{
            
        case .cities:
            return cityListModel.cityList.count
        case .types:
            return typeListModel.typeList.count
        case .brands:
            return brandListModel.brandList.count
        
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: typeListTableViewCellId, for: indexPath)
        
        
        if let cell = cell as? TypeListTableViewCell,
            let segmentTitle = saveInfoStruct.getWhichSegmentedTitle(),
            let images = standardImageModel.getAllImages()
            {
        
            
            switch segmentTitle{
            
                
            case .cities:
                cell.listTitle.text = cityListModel.cityList[indexPath.row].name
                cell.listImageView.image = images[0]
                cell.listDetail.text = cityListModel.cityList[indexPath.row].number
                
                
            case .types:
                cell.listTitle.text = typeListModel.typeList[indexPath.row].name
                cell.listDetail.text = typeListModel.typeList[indexPath.row].number
                cell.listImageView.image = images[1]
                
            case .brands:
                cell.listTitle.text = brandListModel.brandList[indexPath.row].name
                cell.listDetail.text = brandListModel.brandList[indexPath.row].number
                cell.listImageView.image = images[2]
                
                
            }
            
            
            return cell
        }
        
        print("沒有進")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    
   
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var urlStr : String = ""
        
        var selectAPI : WhichAPIGet?
        
        guard let segmentTitle = saveInfoStruct.getWhichSegmentedTitle() else {return }
        
        switch segmentTitle{
            
        case .cities:
            
            let parameter = cityListModel.cityList[indexPath.row].number
            urlStr = "\(ICLICK_URL)\(getPanoValueCityURL)\(parameter)"
            selectAPI = .cityDetail
            
        case .types:
            
            let parameter = typeListModel.typeList[indexPath.row].name
            urlStr = "\(ICLICK_URL)\(getPanoValueTagURL)\(parameter)"
            selectAPI = .typeDetail
        
        case .brands:
            
            let parameter = brandListModel.brandList[indexPath.row].number
            urlStr = "\(ICLICK_URL)\(GET_PANOBRAND_URL)\(parameter)"
            selectAPI = .brandDetail
            
            print("URL\(urlStr)")
        }
        
        
        guard let selectedAPI = selectAPI else { return }
        
        //When cell be clicked , save under parameter on SaveInfoStruct,let can be use on next SubSortTableViewController.
        saveInfoStruct.setWhich(selectedAPI: selectedAPI)
        saveInfoStruct.whichUrlStr = urlStr
        
        
        
    }
    
}



