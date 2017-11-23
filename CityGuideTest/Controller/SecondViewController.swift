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

var saveInfoStruct = SaveInfoStruct.standard()

//ObjectCache
let cacheObjectData = NSCache<AnyObject, AnyObject>()

//Image constant
let standardiClickImage = IClickImageModel.standard()
let standardImageModel = ImageDataModel.standard()

/**
 The entry view , it show the popular information and type list with segment.
 */
class SecondViewController: UIViewController {
    
    
    let typeListCoordinator = TypeListTableViewCoordinator()
    
    var searchControll : UISearchController!
    var searchBar: UISearchBar!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
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
        
        addIndicatorView(activityIndicator: activityIndicator)
        
        connectToServer()
        
        standardImageModel.handleAllImage(names: ["0.jpg","1.jpg","2.jpg","3.jpg"])

        
        //Setting scrollView's contentSize
        popScrollView.delegate = self
        popScrollView.isPagingEnabled = true
        popScrollView.isDirectionalLockEnabled = true
        
        //Set image on scrollView
        setImageViewOnScrollView()
        
        //SearchControll
        searchControll = UISearchController(searchResultsController: nil)
        searchControll.searchBar.placeholder = "search here..."
        searchControll.searchBar.showsCancelButton = true
        searchControll.searchBar.delegate = self
        
        searchBar = UISearchBar()
        searchBar.placeholder = "search here..."
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.endEditing(true)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSearchBarGesture(sender:)))
//
//        searchBar.addGestureRecognizer(tapGesture)
        //Recognize the device version
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        
//        if #available (iOS 11.0, *){
//            self.navigationItem.searchController = searchControll
//        }else {
            self.navigationItem.titleView = searchBar
//        }
        
        //Set the segmentedControl
        pageSegmentedControl.addTarget(self, action: #selector(onSegementedControlSelect(sender:)), for: .valueChanged)
        
        settingPageControl()
        
        //Connect tableView's delegate on Coordinator
        typeListTableView.delegate = typeListCoordinator
        typeListTableView.dataSource = typeListCoordinator
//        typeListTableView.rowHeight = UITableViewAutomaticDimension
        
        //For tableview gesture
        setupTheTableViewGesture()
        typeListTableView.isEditing = false
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Gesture
    @objc func tapSearchBarGesture(sender: UITapGestureRecognizer){
        searchBar.showsCancelButton = true
        
    }
    
    func setupTheTableViewGesture(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipGestureRecognizer(sender:)))
//        swipe.direction = .right
        typeListTableView.addGestureRecognizer(swipe)
        
    }
    
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
    
    
    
    func addIndicatorView(activityIndicator: UIActivityIndicatorView){
        
        self.typeListTableView.addSubview(activityIndicator)
        
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
    
    

    
    /**
     To set the popular Image and show imageLabel method
     
     */
    func setImageViewOnScrollView(){
        
        let imageName = ["0.jpg","1.jpg","2.jpg","3.jpg"] //FIXME: - connect the image source
        
        guard let popViewSize = scrollSize else { return  }
        
        let imageViewSize = popViewSize
        
        for (i,name) in imageName.enumerated(){
            
            let muchImageView = UIImageView(image: UIImage(named: name))
            let xPosition = self.view.frame.width * CGFloat(i)
            
            muchImageView.frame = CGRect(x: xPosition, y: 0, width: popViewSize.width, height: popViewSize.height)
            
            muchImageView.contentMode = .scaleAspectFit
            
            self.popScrollView.contentSize.width = self.popScrollView.frame.width * CGFloat(i + 1)
            
            let labelHight = imageViewSize.height/5
            let imageLabel = UILabel(frame: CGRect(x: xPosition,
                                                   y: imageViewSize.height - labelHight,
                                                   width: imageViewSize.width/2,
                                                   height: labelHight))
            imageLabel.text = "This is Place name: \(name)"
            imageLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
            imageLabel.textColor = UIColor.white
            imageLabel.textAlignment = .center
            imageLabel.font = UIFont(name: "Helvetica-light" , size: labelHight)
            imageLabel.adjustsFontSizeToFitWidth = true
            
            
//            imageViewPositionX += popViewSize.width
            popScrollView.addSubview(muchImageView)
            popScrollView.addSubview(imageLabel)
            
        }
        
    }
    
    
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
        
        popPageControl.numberOfPages = 4
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
        
        
        
    }
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        //Prepare for segue
    }
}

