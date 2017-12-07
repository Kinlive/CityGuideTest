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
    
    let downloadImgQueue = OperationQueue()
    let communicator = Communicator()
    let cache = NSCache<AnyObject,AnyObject>()
    let fileManager = FileManager.default
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TYPELISTTABLEVIEWCELL_ID, for: indexPath)
        
        
        if let cell = cell as? TypeListTableViewCell,
            let segmentTitle = saveInfoStruct.getWhichSegmentedTitle()
//            let images = standardImageModel.getAllImages()
            {
            cell.listImageView.image = UIImage(named: "placeholder.png")
            
            switch segmentTitle{
            
                
            case .cities:
                let cityListObject = cityListModel.cityList[indexPath.row]
                cell.listTitle.text = cityListObject.name
//                cell.listDetail.text = cityListObject.number
                let imgName = cityListObject.img.first ?? "noImg"
                let imgId = cityListObject.id
                
                let imgUrl = "\(ICLICK_URL)\(GET_CITYIMG_URL)\(imgId)\(GET_COMPRESS_IMG)"
                let cacheKey = "\(CheckWhichDataFrom.fromList)\(imgName)"
                let fileURL = componentURL(documentPath: getDocumentsDirectory(),
                                           with: cacheKey)
//                print("fileURL: \(fileURL)=======")
//                print("cacheKey: \(cacheKey)=====")
                //To estimate img had exist on cache or document directory.
                if (cache.object(forKey: cacheKey as AnyObject) != nil){
                    print("Cached image used, no need to download it")
                    
                    cell.listImageView.image = cache.object(forKey: cacheKey as AnyObject) as? UIImage
                    
                    
                }else if(fileManager.fileExists(atPath: fileURL.path)){
                    
                    cell.listImageView.image = getImgFromSandboxOn(url: fileURL)
                    print("Get on sandBox")
                    
                }else{
                    downloadImgQueueMethod(imageUrlStr: imgUrl, completion: { (success, img) in
                        if success{
                            OperationQueue.main.addOperation {
                                if
                                    let updataCell = tableView.cellForRow(at: indexPath) as? TypeListTableViewCell,
                                    let finalImg = img{
                                    updataCell.listImageView.image = finalImg
                                    
                                    //Save on cache
                                    self.cache.setObject(finalImg, forKey: cacheKey as AnyObject)
                                    //Save on document directory
                                    self.saveImgToSandboxWith(cacheKey: cacheKey, img: finalImg)
                                    
                                    print("Save end")
                                    
                                }
                            }
                        }else{
                            print("Not found the img")
                            let newImgUrl = "\(ICLICK_URL)\(GET_CITYIMG_URL)\(imgId)\(GET_COMPRESS_PNG)"
                            self.downloadImgQueueMethod(imageUrlStr: newImgUrl, completion: { (success, img) in
                                if success{
                                    OperationQueue.main.addOperation {
                                        if let updateCell = tableView.cellForRow(at: indexPath) as? TypeListTableViewCell, let finalImg = img{
                                            updateCell.listImageView.image = finalImg
                                            //Save on cache
                                            self.cache.setObject(finalImg, forKey: cacheKey as AnyObject)
                                            //Save on document directory
                                            self.saveImgToSandboxWith(cacheKey: cacheKey, img: finalImg)
                                            
                                            
                                        }
                                    }
                                }
                            })
                        
                        }
                    })
                }
                
                
                
//                cell.listImageView.image = images[0]
                
            case .types:
                let tagListObject = typeListModel.typeList[indexPath.row]
                cell.listTitle.text = tagListObject.name
//                cell.listDetail.text = tagListObject.number
                
                let imgName = tagListObject.img.first ?? "noImg"
                let imgId = tagListObject.id
                
                let imgUrl = "\(ICLICK_URL)\(GET_TAGIMG_URL)\(imgName)"
                let cacheKey = "\(CheckWhichDataFrom.fromList)\(imgName)"
                let fileURL = componentURL(documentPath: getDocumentsDirectory(),
                                           with: cacheKey)
                
                //To estimate img had exist on cache or document directory.
                if (cache.object(forKey: cacheKey as AnyObject) != nil){
                    print("Cached image used, no need to download it")
                    
                    cell.listImageView.image = cache.object(forKey: cacheKey as AnyObject) as? UIImage
                    
                    
                }else if(fileManager.fileExists(atPath: fileURL.path)){
                    
                    cell.listImageView.image = getImgFromSandboxOn(url: fileURL)
                    print("Get on sandBox")
                    
                }else{
                    downloadImgQueueMethod(imageUrlStr: imgUrl, completion: { (success, img) in
                        if success{
                            OperationQueue.main.addOperation {
                                if
                                    let updataCell = tableView.cellForRow(at: indexPath) as? TypeListTableViewCell,
                                    let finalImg = img{
                                    updataCell.listImageView.image = finalImg
                                    
                                    //Save on cache
                                    self.cache.setObject(finalImg, forKey: cacheKey as AnyObject)
                                    //Save on document directory
                                    self.saveImgToSandboxWith(cacheKey: cacheKey, img: finalImg)
                                    print("Save end")
                                    
                                    
                                }
                            }
                        }else{// If jpg now found img then try png again.
                            print("Not found the img")
                            let newImgUrl = "\(ICLICK_URL)\(GET_TAGIMG_URL)\(imgName)"
                            self.downloadImgQueueMethod(imageUrlStr: newImgUrl, completion: { (success, img) in
                                if success{
                                    OperationQueue.main.addOperation {
                                        if let updateCell = tableView.cellForRow(at: indexPath) as? TypeListTableViewCell, let finalImg = img{
                                            updateCell.listImageView.image = finalImg
                                            //Save on cache
                                            self.cache.setObject(finalImg, forKey: cacheKey as AnyObject)
                                            //Save on document directory
                                            self.saveImgToSandboxWith(cacheKey: cacheKey, img: finalImg)
                                            
                                            
                                        }
                                    }
                                }else{
                                    print("Not found the img on png download.")
                                }
                            })
                        }
                    })
                }
//                cell.listImageView.image = images[1]
                
            case .brands:
                let brandListObject = brandListModel.brandList[indexPath.row]
                cell.listTitle.text = brandListObject.name
//                cell.listDetail.text = brandListObject.number
//                cell.listImageView.image = images[2]
                
                let imgName = brandListObject.img.first ?? "noImg"
                let imgId = brandListObject.id
                let imgUrl = "\(ICLICK_URL)\(GET_BRANDIMG_URL)\(imgId)\(GET_COMPRESS_IMG)"
                let cacheKey = "\(CheckWhichDataFrom.fromList)\(imgName)"
                let fileURL = componentURL(documentPath: getDocumentsDirectory(),
                                           with: cacheKey)
                
                //To estimate img had exist on cache or document directory.
                if (cache.object(forKey: cacheKey as AnyObject) != nil){
                    print("Cached image used, no need to download it")
                    
                    cell.listImageView.image = cache.object(forKey: cacheKey as AnyObject) as? UIImage
                    
                    
                }else if(fileManager.fileExists(atPath: fileURL.path)){
                    
                    cell.listImageView.image = getImgFromSandboxOn(url: fileURL)
                    print("Get on sandBox")
                    
                }else{
                    downloadImgQueueMethod(imageUrlStr: imgUrl, completion: { (success, img) in
                        if success{
                            OperationQueue.main.addOperation {
                                if
                                    let updataCell = tableView.cellForRow(at: indexPath) as? TypeListTableViewCell,
                                    let finalImg = img{
                                    updataCell.listImageView.image = finalImg
                                    
                                    //Save on cache
                                    self.cache.setObject(finalImg, forKey: cacheKey as AnyObject)
                                    //Save on document directory
                                    self.saveImgToSandboxWith(cacheKey: cacheKey, img: finalImg)
                                    print("Save end")
                                    
                                }
                            }
                        }else{
                            print("Not found the img")
                            let newImgUrl = "\(ICLICK_URL)\(GET_BRANDIMG_URL)\(imgId)\(GET_COMPRESS_PNG)"
                            self.downloadImgQueueMethod(imageUrlStr: newImgUrl, completion: { (success, img) in
                                if success{
                                    OperationQueue.main.addOperation {
                                        if let updateCell = tableView.cellForRow(at: indexPath) as? TypeListTableViewCell, let finalImg = img{
                                            updateCell.listImageView.image = finalImg
                                            //Save on cache
                                            self.cache.setObject(finalImg, forKey: cacheKey as AnyObject)
                                            //Save on document directory
                                            self.saveImgToSandboxWith(cacheKey: cacheKey, img: finalImg)
                                            
                                        }
                                    }
                                }else{
                                     print("Not found the img on png download.")
                                }
                            })
                            
                        }
                    })
                }
                
            }
            
            
            return cell
        }
        
        print("沒有進")
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 100
//        
//    }
    
   
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var urlStr : String = ""
        
        var selectAPI : WhichAPIGet?
        
        guard let segmentTitle = saveInfoStruct.getWhichSegmentedTitle() else {return }
        
        switch segmentTitle{
            
        case .cities:
            
            let parameter = cityListModel.cityList[indexPath.row].number
            urlStr = "\(ICLICK_URL)\(GET_PANOCITY_URL)\(parameter)"
            selectAPI = .cityDetail
            
        case .types:
            
            let parameter = typeListModel.typeList[indexPath.row].name
            urlStr = "\(ICLICK_URL)\(GET_PANOTAG_URL)\(parameter)"
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
   
    
    
    typealias HandleCompletion = (Bool, UIImage?) -> Void
    //MARK: - downloadImg Method.
    /**
     Start to download image on server
     - Parameter imageUrlStr: On func cellForRow, define:"\(iclickURL)\(getImageURL)\(imageName)"
     - Parameter completion: when image download end, get (Bool , UIImage)
     */
    func downloadImgQueueMethod(imageUrlStr: String, completion: @escaping HandleCompletion){
        
        //Create an operationQueue
        downloadImgQueue.addOperation {
            
            //Connect to server
            self.communicator.connectToServer(urlStr: imageUrlStr, whichApiGet: nil, completion: { (success) in
                if success{
                    
                    if let imgUrl = URL(string: imageUrlStr),
                        //With path to find the imgdata and convert the img data
                        let data = try? Data(contentsOf: imgUrl),
                        let img = UIImage(data: data)
                    {
                        //Compress the image when downloaded.
                        let lowQualityImg = UIImage.compressImageQuality(img, toByte: 5000)
                        
                        completion(true, lowQualityImg)
                        
                    }else{//URL or data or image invalid
                        
                        completion(false, nil)
                        
                    }
                }else{//connect fail
                    
                    completion(false, nil)
                }
            })
        }
    }
    
    //MARK: - Save img to sandbox func.
    /**
     When image downloaded, save image on device.
     - Parameter cacheKey: On func cellForRow define:"\(segmentTitle)\(imageName)".
     - Parameter img: Compressed low quality image.
     */
    func saveImgToSandboxWith(cacheKey: String, img: UIImage){
        
        //Prepare data for save.
        if let data = UIImageJPEGRepresentation(img, 0.5) {
            
            //Prepare the file path.
            let imgURL = componentURL(documentPath: getDocumentsDirectory(), with: cacheKey)
            
            do {
                
                try data.write(to: imgURL)
                
            }catch let error{ //Save to document directory fail.
                
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    //MARK: - Get img from sandbox
    /**
     When check image is exist on device,get from document directory.
     - Parameter url: DocumentPath+cacheKey.
     - Returns: Image from document directory.
     */
    func getImgFromSandboxOn(url: URL) -> UIImage?{
        
        
        do{
            let imgFile = try Data.init(contentsOf: url)
            
            return UIImage(data: imgFile)
            
            
        }catch let error {
            print(error.localizedDescription)
            return nil
        }
        
        
    }
    
    //MARK: - Get Document directory
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
        
    }
    
    //MARK: - Component the document's path and cache key
    func componentURL(documentPath: URL, with cacheKey: String) -> URL{
        
        let finalURL = documentPath.appendingPathComponent(cacheKey)
        
        return finalURL
        
    }
    
    
}



