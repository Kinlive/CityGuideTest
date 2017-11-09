//
//  SubSortTableViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/3.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class SubSortTableViewController: UITableViewController {

    let communicator = Communicator()
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    //Cache the SubSort cell's image
    
    let cache = NSCache<AnyObject, AnyObject>()
    
    let downloadImgQueue = OperationQueue()
    
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        addIndicatorView(activityIndicator: activityIndicator)
        
        connectToServer()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        

        
        if let whichApi = saveInfoStruct.getWhichSelectedAPI(){
        
            if whichApi == .cityDetail{
                cityDetailListModel.cityDetailList.removeAll()
                print("CityDetailList was cleared!")
                
            }else if whichApi == .typeDetail{
                typeDetailListModel.typeDetailList.removeAll()
                
            }else if whichApi == .brandDetail{
                brandDetailListModel.brandDetailList.removeAll()
            }
        
        }
        
    }
    
    
    //MARK: - Add activityIndicator on tableView
    func addIndicatorView(activityIndicator: UIActivityIndicatorView){
        
        self.tableView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        activityIndicator.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).withAlphaComponent(0.7)
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator,
                                                      attribute: NSLayoutAttribute.centerX,
                                                      relatedBy: NSLayoutRelation.equal,
                                                      toItem: view,
                                                      attribute: NSLayoutAttribute.centerX,
                                                      multiplier: 1,
                                                      constant: 0)
        
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator,
                                                    attribute: NSLayoutAttribute.centerY,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: view,
                                                    attribute: NSLayoutAttribute.centerY,
                                                    multiplier: 1,
                                                    constant: 0)
        view.addConstraint(verticalConstraint)
        
        
    }
    
    
    
    //MARK: - Connect to service
    func connectToServer(){
        
        guard
            let urlStr = saveInfoStruct.whichUrlStr,
            let whichApiGet = saveInfoStruct.getWhichSelectedAPI()
            else {
                
                fatalError("urlStr or whichApiGet is nil.")
                
        }
        
        
        activityIndicator.startAnimating()
        communicator.connectToService(urlStr: urlStr , whichApiGet: whichApiGet, completion: { (success) in
            if success {
                
                //put segue on here , let it be request end to go next view
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                    self.tableView.reloadData()
                    
                }
                
                
                
            }else {
                print("Connect Fail...")
            }
        })
        
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let segmentTitle = saveInfoStruct.getWhichSegmentedTitle() else {
          
            
            fatalError("saveInfoStruct.getWhichSegmentedTitle isn't get.")
            
            }
        
        switch segmentTitle{
            
        case .cities:
            
            
            return cityDetailListModel.cityDetailList.count
            
        case .types:
            
            return typeDetailListModel.typeDetailList.count
        case .brands:
            
            
            return brandDetailListModel.brandDetailList.count
        
        
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: subSortTableViewCellId, for: indexPath)

        if let cell = cell as? SubSortTableViewCell,
            let segmentTitle = saveInfoStruct.getWhichSegmentedTitle(){
            
            cell.subSortImageView.image = UIImage(named: "placeholder.png")
            
            switch segmentTitle{
            
                case .cities:
                    cell.subSortTitle.text = cityDetailListModel.cityDetailList[indexPath.row].name
                    cell.subSortSummery.text = ""
//                        cityDetailListModel.cityDetailList[indexPath.row].summary
                    
                    let imageName = "\(cityDetailListModel.cityDetailList[indexPath.row].img[0])"
                   
                    let cacheKey = "\(segmentTitle)\(imageName)"
                    
//                    print("=====Let print cacheKey: \(cacheKey)")
                    
                    let fileURL = componentURL(documentPath: getDocumentsDirectory(),
                                               with: cacheKey)
 
                    print("fileExist:?\(fileManager.fileExists(atPath: fileURL.path))")
                    
            //To estimate img had exist on cache or document directory.
                    if (cache.object(forKey: cacheKey as AnyObject) != nil){
                        print("Cached image used, no need to download it")
                        
                        cell.subSortImageView.image = cache.object(forKey: cacheKey as AnyObject) as? UIImage
                        
                        
                    }else if(fileManager.fileExists(atPath: fileURL.path)){
                        ////
                        cell.subSortImageView.image = getImgFromSandboxOn(url: fileURL)
                        print("Get on sandBox")
                        
                    }else{
                     
                        let imageUrlStr = "\(iclickURL)\(getImageURL)\(imageName)"
                        
                        downloadImgQueueMethod(imageUrlStr: imageUrlStr, completion: { (success, img) in
                            
                            OperationQueue.main.addOperation {
                                if let updataCell = tableView.cellForRow(at: indexPath) as? SubSortTableViewCell,
                                    let lowImg = img
                                {
                                    
                                    updataCell.subSortImageView.image = lowImg
                                    
                                    self.cache.setObject(lowImg, forKey: cacheKey as AnyObject)
                                    
                                    self.saveImgToSandboxWith(cacheKey: cacheKey, img: lowImg)
                                    print("First save on cacheObject!")
                                }
                            }
                        })
                    }
                
                
                case .types:
                    
                    cell.subSortTitle.text = typeDetailListModel.typeDetailList[indexPath.row].name
                    cell.subSortSummery.text = typeDetailListModel.typeDetailList[indexPath.row].summary
                

                case .brands:
                
                    cell.subSortTitle.text = brandDetailListModel.brandDetailList[indexPath.row].name
                    cell.subSortSummery.text = brandDetailListModel.brandDetailList[indexPath.row].summary
      
            }
            
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    typealias HandleCompletion = (Bool, UIImage?) -> Void
    //MARK: - downloadImg Method.
    func downloadImgQueueMethod(imageUrlStr: String, completion: @escaping HandleCompletion){
        
        downloadImgQueue.addOperation {
            
            self.communicator.connectToService(urlStr: imageUrlStr, whichApiGet: nil, completion: { (success) in
                if success{
                    
                    if let imgUrl = URL(string: imageUrlStr),
                        let data = try? Data(contentsOf: imgUrl),
                        let img = UIImage(data: data)
                    {
                        
                        let lowQualityImg = UIImage.compressImageQuality(img, toByte: 5000)
                        
                        completion(true, lowQualityImg)
                        
                    }else{
                        
                        completion(false, nil)
                        
                    }
                }else{
                    
                    completion(false, nil)
                }
            })
        }
    }
    
    //MARK: - Save img to sandbox func .
    func saveImgToSandboxWith(cacheKey: String, img: UIImage){
        
        if let data = UIImageJPEGRepresentation(img, 0.5) {
            
            let imgURL = componentURL(documentPath: getDocumentsDirectory(), with: cacheKey)
            
            do {
                
                try data.write(to: imgURL)
                
            }catch let error{
                
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    //MARK: - Get img from sandbox
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
    
//        print(paths[0])
        return paths[0]
        
    }
    
    //MARK: - Component the document's path and cache key
    func componentURL(documentPath: URL, with cacheKey: String) -> URL{
        
        let finalURL = documentPath.appendingPathComponent(cacheKey)
        
        return finalURL
        
    }
    
    
    
    
   
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
