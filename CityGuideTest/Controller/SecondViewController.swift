//
//  SecondViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/10/31.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit


var cityListModel = CityListModel.standard()
var typeListModel = TypeListModel.standard()
var brandListModel = BrandListModel.standard()
var cityDetailListModel = CityDetailListModel.standard()

var saveInfoStruct = SaveInfoStruct.standard()




let standardImageModel = ImageDataModel.standard()

class SecondViewController: UIViewController {
    
    
    let typeListCoordinator = TypeListTableViewCoordinator()
    
    var searchControll : UISearchController!
    
//    let communicator = Communicator()
    
    @IBOutlet weak var popScrollView: UIScrollView!
    
    @IBOutlet weak var popPageControl: UIPageControl!
    
    @IBOutlet weak var pageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var typeListTableView: UITableView!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad先")
        standardImageModel.handleAllImage(names: ["0.jpg","1.jpg","2.jpg","3.jpg"])


        //Setting scrollView's contentSize
        popScrollView.delegate = self
        let scrollViewWidth = popScrollView.frame.size.width
        let scrollViewHeight = popScrollView.frame.size.height
        popScrollView.isPagingEnabled = true
        popScrollView.contentSize = CGSize(width: scrollViewWidth*4, height: scrollViewHeight)
    
        //Set image on scrollView
        setImageViewOnScrollView()
        
        //SearchControll
        searchControll = UISearchController(searchResultsController: nil)
        
        //Recognize the device version
        if #available (iOS 11.0, *){
            self.navigationItem.searchController = searchControll
        }else {
            self.navigationItem.titleView = searchControll.searchBar
        }
        
        //Set the segmentedControl
        pageSegmentedControl.addTarget(self, action: #selector(onSegementedControlSelect(sender:)), for: .valueChanged)
        
        settingPageControl()
        
        //Connect tableView's delegate on Coordinator
        typeListTableView.delegate = typeListCoordinator
        typeListTableView.dataSource = typeListCoordinator
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    /**
     To set Image and show imageLabel method
     
     */
    func setImageViewOnScrollView(){
        
        let imageName = ["0.jpg","1.jpg","2.jpg","3.jpg"] //FIXME: - connect the image source
        
        let imageViewSize = popScrollView.frame.size
        var imageViewPositionX: CGFloat = 0
        let imageViewPositionY: CGFloat = 0
        
        for name in imageName{
            
            let muchImageView = UIImageView(image: UIImage(named: name))
            muchImageView.frame.size = imageViewSize
            muchImageView.frame.origin.y = imageViewPositionY
            muchImageView.frame.origin.x = imageViewPositionX
            
            
            let labelHight = imageViewSize.height/5
            let imageLabel = UILabel(frame: CGRect(x: imageViewPositionX,
                                                   y: imageViewSize.height - labelHight,
                                                   width: imageViewSize.width/2,
                                                   height: labelHight))
            imageLabel.text = "This is loekwokwedeiwjfeo \(name)"
            imageLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
            imageLabel.textColor = UIColor.white
            imageLabel.textAlignment = .center
            imageLabel.font = UIFont(name: "Helvetica-light" , size: labelHight)
            imageLabel.adjustsFontSizeToFitWidth = true
//            imageLabel.adjustsFontForContentSizeCategory = true
            
            
            imageViewPositionX += imageViewSize.width
            popScrollView.addSubview(muchImageView)
            popScrollView.addSubview(imageLabel)
            
        }
        
    }
    
    
    /**
     When segmentedControl be selected one, it will call this method
     
     - Parameter sender: Get which title be selected
     */
    @objc func onSegementedControlSelect(sender: UISegmentedControl){
        
   
        
        print("Now is \(sender.selectedSegmentIndex) be selected ")
        
        print(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "No selected")
        
        switch sender.selectedSegmentIndex{
            case 0:
                
                saveInfoStruct.setWhich(segmentTitle: .cities)
                
            case 1:
//                typeListCoordinator.segmentTitle = .types
                saveInfoStruct.setWhich(segmentTitle: .types)
            
            case 2:
//                typeListCoordinator.segmentTitle = .brands
                saveInfoStruct.setWhich(segmentTitle: .brands)
            
            default:
                break
        }
        
        typeListTableView.reloadData()
        
//        typeListModel.toString()
        
        
        
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
        
        let page = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        
        popPageControl.currentPage = page
        
    }
    
}

