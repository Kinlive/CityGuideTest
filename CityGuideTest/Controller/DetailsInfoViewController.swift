//
//  DetailsInfoViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/13.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class DetailsInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let maxHeight: CGFloat = 250.0
    let minHeight: CGFloat = 50.0
    
    
    @IBOutlet weak var titleImgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailsInfoTableView: UITableView!{
        didSet{
            detailsInfoTableView.contentInset = UIEdgeInsets(top: maxHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!{
        didSet{
            heightConstraint.constant = maxHeight
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsInfoTableView.delegate = self
        detailsInfoTableView.dataSource = self
        
        setupTableViewCell()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupTableViewCell() {
        
        guard
            let segmentTitle = saveInfoStruct.getWhichSegmentedTitle(),
            let selectedIndexPath = saveInfoStruct.getSelectedIndexPath()
            else {return }
        var imageName: String?
        var titleName: String?
        
        switch  segmentTitle {
        case .cities:
            //Prepare for cacheKey get.
            imageName = cityDetailListModel.cityDetailList[selectedIndexPath.row].img[0]
            titleName = cityDetailListModel.cityDetailList[selectedIndexPath.row].name
            
            
        case .types:
            imageName = typeDetailListModel.typeDetailList[selectedIndexPath.row].img[0]
            titleName = typeDetailListModel.typeDetailList[selectedIndexPath.row].name
            
        case .brands:

            imageName = brandDetailListModel.brandDetailList[selectedIndexPath.row].img[0]
            titleName = brandDetailListModel.brandDetailList[selectedIndexPath.row].name
            
        }
        
        guard
            let imgName = imageName,
            let title = titleName else {return }
        
        let cacheKey = "\(segmentTitle)\(imgName)"
       
        //Get image with cacheKey.
        guard let img = getImgWith(cacheKey: cacheKey) else {return}
        
        //Setup title and image.
        self.titleImgView.image = img
        self.titleLabel.text = title

    }
    
 
    //MARK: - Get img on document directory or cache file
    func getImgWith(cacheKey: String) -> UIImage?{
     
        //ComponentURL of document directory with cacheKey.
        let fileURL = componentURL(documentPath: getDocumentsDirectory(), with: cacheKey)
        
        //To check file exist.
        if FileManager.default.fileExists(atPath: fileURL.path){
            //if true to get image on document
            guard let img = getImgFromSandboxOn(url: fileURL) else {return nil}
            return img
            
        }else {//file not exist.
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
    
    
    //MARK: - TableView delegate & datasource.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderCell")
        
        if let cell = cell as? DetailsInfoTableViewCell{
            
            cell.detailTitleLabel.text = "\(indexPath.row)"
            
            return cell
        }
        
        return cell!
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0{
            heightConstraint.constant = max(fabs(scrollView.contentOffset.y), minHeight)
        }else{
            heightConstraint.constant = minHeight
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
