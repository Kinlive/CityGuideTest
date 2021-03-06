//
//  SecondViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/10/31.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

//Define constant here.
var cityListModel = CityListModel.standard()
var typeListModel = TypeListModel.standard()
var brandListModel = BrandListModel.standard()

var cityDetailListModel = CityDetailListModel.standard()
var typeDetailListModel = TypeDetailListModel.standard()
var brandDetailListModel = BrandDetailListModel.standard()
var searchResultModel = SearchResultModel.standard()
var topPlaceResultModel = TopPlaceResultModel.standard()
var panoramaModel = PanoramaModel.standard()
var guideMapModel = GuideMapModel.standard()

var saveInfoStruct = SaveInfoStruct.standard()

//ObjectCache
let cacheObjectData = NSCache<AnyObject, AnyObject>()

//Image constant
let standardiClickImage = IClickImageModel.standard() // no use
let standardImageModel = ImageDataModel.standard()

/**
 The entry view , it show the popular information and type list with segment.
 */
class SecondViewController: UIViewController {
    
    
    let typeListCoordinator = TypeListTableViewCoordinator()
    
    var searchControll : UISearchController!
    var searchBar: UISearchBar!
    
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    let scrollActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray )
    
    //For 5 topmost place use.
    let topOperator = OperationQueue()
    var nextVcTopObject: TopPlaceResultObject?
    
    
//    var refreshCtrl: UIRefreshControl!
    var scrollSize: CGSize!
    
    var fullSize: CGSize!
    var fullWidth: CGFloat = 0
    var fullHeight: CGFloat = 0
    
    
    
    @IBOutlet weak var popScrollView: UIScrollView!
    
    @IBOutlet weak var popPageControl: UIPageControl!
    
    @IBOutlet weak var pageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var typeListTableView: UITableView!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prepare for scrollView
        fullSize = UIScreen.main.bounds.size
        fullWidth = fullSize.width
        fullHeight = fullSize.height
        popScrollView.frame = CGRect(x: 0, y: 0, width: fullWidth, height: fullHeight/3)
        scrollSize = popScrollView.bounds.size
        
        //Default value set.
        saveInfoStruct.setWhich(segmentTitle: .cities)
        
        //Add loading activityIndicator on tableView 
        
        addIndicatorView(activityIndicator: activityIndicator, superView: typeListTableView)
        addIndicatorView(activityIndicator: scrollActivityIndicator, superView: popScrollView)
        
        connectToServer()
        
        
        //Setting scrollView's contentSize
        popScrollView.delegate = self
        popScrollView.isPagingEnabled = true
        popScrollView.isDirectionalLockEnabled = true
        

        //Set top 5 place on scrollView
        requestForTopPlaces()
        
        //Set searchBar.
        searchBar = UISearchBar()
        searchBar.placeholder = "search here..."
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.endEditing(true)
        

        //Recognize the device version
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        
//        if #available (iOS 11.0, *){
//            self.navigationItem.searchController = searchControll
//        }else {
            self.navigationItem.titleView = searchBar
//        }
        
        //Set the segmentedControl
        pageSegmentedControl.addTarget(self, action: #selector(onSegementedControlSelect(sender:)), for: .valueChanged)
        
        
        
        //Connect tableView's delegate on Coordinator
        typeListTableView.delegate = typeListCoordinator
        typeListTableView.dataSource = typeListCoordinator
        
        //For tableview gesture
        setupTheTableViewGesture() //FIXME: - No use now , tableView's gesture.
        typeListTableView.isEditing = false
        
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        //Set default is not search.
        saveInfoStruct.isSearchNow = .noSearch
        
        searchBar.showsCancelButton = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("連到VC前是否有經過這裡？")
        if segue.destination is DetailsInfoViewController,
            let nextVc = segue.destination as? DetailsInfoViewController,
            let topObject = nextVcTopObject{
         
            //Prepare detail data for next vc.
            nextVc.imageName = topObject.img.first ?? "noImg"
            nextVc.titleName = topObject.name
            nextVc.itemSummary = topObject.content == "" ?topObject.summary:topObject.content
            nextVc.itemCoordinateStr = topObject.map
            nextVc.itemAddress = topObject.address
            nextVc.itemId = topObject.id
            saveInfoStruct.mapPanoUrl = topObject.panorama
            saveInfoStruct.guideMapImageName = topObject.guideMap
            saveInfoStruct.youtubeID = topObject.youtube
            let imgName = topObject.img.first ?? "noImg"
            let imgCacheKey = "\(CheckWhichDataFrom.fromTopPlace)\(imgName)"
            print("Cache the img key : \(imgCacheKey)")
            
            nextVc.beforeVcCacheKey = imgCacheKey
            
//            var titleName = "Title Test"
//            if let newTitle = nextVc.titleName{
//                titleName = newTitle
//            }
            
//            nextVc.titelLabel.text = titleName
//            nextVc.titleImg.image = img
            nextVc.whichDataFrom = .fromTopPlace
            
        }
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    //MARK: - No use now, setupTheTableViewGesture() .
    func setupTheTableViewGesture(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipGestureRecognizer(sender:)))
//        swipe.direction = .right
        typeListTableView.addGestureRecognizer(swipe)
        
    }
    //MARK: - No use now, swipGestureRecognizer
   @objc func swipGestureRecognizer(sender: UISwipeGestureRecognizer){
        
    switch  sender.direction {
        
    case .left: //next one
        
        print("NEXT")
    case .right: // before one
        
        print("Before")
    default:
        break
    }
    
    
    }
    
    //MARK: - Request for the 5 topmost vote place.
    func requestForTopPlaces(){
        scrollActivityIndicator.startAnimating()
        let communicator = Communicator()
        let url = "\(ICLICK_URL)\(GET_HOTPLACE_URL)"
        
        //First request for detail list.
        communicator.connectToServer(urlStr: url, whichApiGet: WhichAPIGet.downloadImg, completion: { (success) in
            if success{
                OperationQueue.main.addOperation {
                    self.settingPageControl()
                    self.setImageViewOnScrollView()
                }
                

            }
        })
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
        topOperator.addOperation {
            
            let communicator = Communicator()
            //Connect to server
            communicator.connectToServer(urlStr: imageUrlStr, whichApiGet: nil, completion: { (success) in
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
    
    
    
    //MARK: - ConnectToServer func.
    func connectToServer(){
        
        
        let communicator = Communicator()
        activityIndicator.startAnimating()
        
//        print("\(ICLICK_URL)\(GET_CITYLIST_URL)")
        communicator.connectToServer(urlStr: "\(ICLICK_URL)\(GET_CITYLIST_URL)", whichApiGet: .cityList) { (success) in
            if success {
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                    self.typeListTableView.reloadData()
                    
                }
                
                print("CityList Connect success!")
                
            }else{
                print("CityList Connect fail....")
            }
        }
        
        communicator.connectToServer(urlStr: "\(ICLICK_URL)\(GET_TYPELIST_URL)", whichApiGet: .typeList) { (success) in
            if success{
                
                DispatchQueue.main.async {
                    
                    self.typeListTableView.reloadData()
                }
                print("TypeList Connect success!")
            }else{
                print("TypeList Connect fail....")
            }
        }
        communicator.connectToServer(urlStr: "\(ICLICK_URL)\(GET_BRANDLIST_URL)", whichApiGet: .brandList) { (success) in
            if success {
                
                DispatchQueue.main.async {
                    
                    self.typeListTableView.reloadData()
                }
                print("BrandList Connect success!")
            }else {
                print("BrandList Connect fail....")
            }
        }
    }
    
    
    
    func addIndicatorView(activityIndicator: UIActivityIndicatorView, superView: UIView){
        
//        self.typeListTableView.addSubview(activityIndicator)
        superView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
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
    
    

    //MARK: - SetImageViewOnScrollView func.
    /**
     To set the popular Image and show imageLabel method
     
     */
    func setImageViewOnScrollView(){
        
        guard let popViewSize = scrollSize else { return  }
        
        let imageViewSize = popViewSize
        
        for (i,topPlaceObject) in topPlaceResultModel.topPlaceResultList.enumerated() {
            
            //Prepare the btn for top place.
            let btnImageView = UIButton()
            btnImageView.setBackgroundImage(UIImage(named: "placeholder.png"), for: .normal)
            btnImageView.tag = i
            btnImageView.addTarget(self, action: #selector(onTopPlaceBtnTap(sender:)), for: .touchUpInside)
            
            //Prepare the img url for second request.
            let imgName = topPlaceObject.img.first ?? "noImg"
            let imgId = topPlaceObject.id
            let urlStr = "\(ICLICK_URL)\(GET_PLACEIMG_URL)\(imgName)"
            let imgCacheKey = "\(CheckWhichDataFrom.fromTopPlace)\(imgName)"
            //Second request for download img.
            topOperator.addOperation {
                self.downloadImgQueueMethod(imageUrlStr: urlStr, completion: { (success, img) in
                    if success , let finalImg = img{
                        OperationQueue.main.addOperation {
                            
                            btnImageView.setBackgroundImage(finalImg, for: .normal)
                            self.saveImgToSandboxWith(cacheKey: imgCacheKey, img: finalImg)
                            print("Save Img key is : \(imgCacheKey)")
                        }
                        
                    }else{
                        print("Download the top img fail.")
                        
                    }
                })
            }
            
          //Init the imageView and labelView.
            let xPosition = self.view.frame.width * CGFloat(i)
            
            btnImageView.frame = CGRect(x: xPosition, y: 0, width: popViewSize.width, height: popViewSize.height)
            btnImageView.contentMode = .scaleToFill
            
            self.popScrollView.contentSize.width = self.popScrollView.frame.width * CGFloat(i + 1)
            
            let labelHight = imageViewSize.height/5
            let imageLabel = UILabel(frame: CGRect(x: xPosition,
                                                   y: imageViewSize.height - labelHight,
                                                   width: imageViewSize.width/2,
                                                   height: labelHight))
            
       
            imageLabel.text = "\(topPlaceObject.name)"
            imageLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
            imageLabel.textColor = UIColor.white
            imageLabel.textAlignment = .center
            imageLabel.font = UIFont(name: "Helvetica-light" , size: labelHight)
            imageLabel.adjustsFontSizeToFitWidth = true
            
            
            popScrollView.addSubview(btnImageView)
            popScrollView.addSubview(imageLabel)
            
            scrollActivityIndicator.stopAnimating()
            scrollActivityIndicator.removeFromSuperview()
        }
        
    }
    
    //MARK: - onTopPlaceBtnTap selector func .
    /**
     On top place image be tapped.
     - Parameter sender: UIButton , get which button be touched.
     */
    @objc func onTopPlaceBtnTap(sender: UIButton){
        
        print("Test for btn's tag pass : \(sender.tag)")
      
        nextVcTopObject = topPlaceResultModel.topPlaceResultList[sender.tag]
            
        self.performSegue(withIdentifier: TOPPLACE_SEGUE, sender: nil)
      
    }
    
    //MARK: - onSegementedControlSelect func.
    /**
     When segmentedControl be selected one, it will call this method.
     
     - Parameter sender: Get which title be selected.
     */
    @objc func onSegementedControlSelect(sender: UISegmentedControl){
        
   
        
        print("Now is \(sender.selectedSegmentIndex) be selected ")

        print(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "No selected")
        
        
        switch sender.selectedSegmentIndex{
            case 0:
                
                saveInfoStruct.setWhich(segmentTitle: .cities)
                
            case 1:

                saveInfoStruct.setWhich(segmentTitle: .types)
            
            case 2:
                saveInfoStruct.setWhich(segmentTitle: .brands)
            
            default:
                break
        }
        
        typeListTableView.reloadData()
        
    }
    
    /**
     Setting with pageControl
     */
    func settingPageControl(){
        
        
        popPageControl.numberOfPages = topPlaceResultModel.topPlaceResultList.count
        popPageControl.currentPage = 0
        popPageControl.isUserInteractionEnabled = false
        
        
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
extension SecondViewController : UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        
        popPageControl.currentPage = page
        
    }
    
}
//UISearchBarDelegate
extension SecondViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }

    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Start search from api.
        if let keyword = searchBar.text{

            saveInfoStruct.keywordOfSearch = keyword
            saveInfoStruct.isSearchNow = .isSearch
            //Prepare for segue.

//            let segue = UIStoryboardSegue(identifier: "SearchSegueId", source: , destination: SubSortTableViewController)

            self.performSegue(withIdentifier: "SearchSegueId", sender: nil)

            searchBar.resignFirstResponder()
//            self.prepare(for: , sender: <#T##Any?#>)

        }
        
    }
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        //Prepare for segue
    }
}

