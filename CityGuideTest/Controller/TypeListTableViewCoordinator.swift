//
//  TypeListTableViewCoordinator.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/10/31.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit
class TypeListTableViewCoordinator: NSObject ,UITableViewDelegate,UITableViewDataSource{
    
    private let cities = ["台北","新北","桃園","新竹","苗栗"]
    private let types = ["下午茶","小確幸","墓園","夜市","觀光"]
    private let brands = ["Meet Taiwna","4G專案","高雄捷運","西門商圈","親子館"]
    
    
    var segmentTitle: SegmentedTitle = .cities
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
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
        
        
        if let cell = cell as? TypeListTableViewCell{
        
            
            switch segmentTitle{
            
                
            case .cities:
                cell.listTitle.text = cityListModel.cityList[indexPath.row].name
//                cell.listImageView.image = images[0]
                cell.listDetail.text = cityListModel.cityList[indexPath.row].number
                
                
            case .types:
                cell.listTitle.text = typeListModel.typeList[indexPath.row].name
                cell.listDetail.text = typeListModel.typeList[indexPath.row].number
//                cell.listImageView.image = images[1]
                
            case .brands:
                cell.listTitle.text = brandListModel.brandList[indexPath.row].name
                cell.listDetail.text = brandListModel.brandList[indexPath.row].number
//                cell.listImageView.image = images[2]
                
                
            }
            
//            cell.listDetail.text = "abcdefgh"
            
            return cell
        }
        
        print("沒有進")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let commucator = Communicator()
        var urlStr : String = ""
        
        var selectSegment : WhichAPIGet?
        
        switch segmentTitle{
            
        case .cities:
            
            let parameter = cityListModel.cityList[indexPath.row].number
            urlStr = "\(iclickURL)\(getPanoValueCityURL)\(parameter)"
            selectSegment = .cityDetail
            
        case .types:
            
            let parameter = typeListModel.typeList[indexPath.row].name
            urlStr = "\(iclickURL)\(getPanoValueTagURL)\(parameter)"
            selectSegment = .typeDetail
            print("testfor url ********** \(urlStr)")
        
        case .brands:
            
            let parameter = brandListModel.brandList[indexPath.row].number
            urlStr = "\(iclickURL)\(getPanoValueBrandURL)\(parameter)"
            selectSegment = .brandDetail
            
        }
        
        
        guard let finalSelectSegment = selectSegment else { return }
        
        commucator.connectToService(urlStr: urlStr, whichApiGet: finalSelectSegment, completion: { (success) in
            if success {
                print("Connect  ok!")
                
            //put segue on here , let it be request end to go next view 
                
                
                
                
            }else {
                print("Connect Fail...")
            }
        })
    }
    
}



