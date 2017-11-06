//
//  ViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/10/30.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var searchController: UISearchController!
    
    var showHotScrollView = UIScrollView()
    
    var pageControl: UIPageControl!
    
    var fullSize: CGSize!
    
    var hotImageView: UIImageView = UIImageView()
    
    var segmentedControl : UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fullSize = UIScreen.main.bounds.size
        
        //MARK: - ScrollView with settings
        settingTheScrollView()
        
        //Put the imageView on scrollView
        let imageViewFrame = CGRect(x: 0,
                                    y: 0,
                                    width: fullSize.width,
                                    height: fullSize.height/3)
        
        hotImageView = UIImageView(frame: imageViewFrame)
        hotImageView.sizeToFit()
        
        
        addImageOnScrollView()
        
        //MARK: - PageControl setting
        settingThePageControl()
        
        
        createShowPageLabel()
        
        
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        
        
        
        if #available(iOS 11.0, *){
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        
        
//        navigationController?.hidesBarsOnSwipe = true
        
        //SegmentedControl
        
        
        settingSegmentedControl()
        
        
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func settingSegmentedControl(){
        
        let segmentedItem = ["地區","主題","品牌"]
        segmentedControl = UISegmentedControl(items: segmentedItem)
        
        segmentedControl.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        segmentedControl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self,
                                   action: #selector(onSegmentedControlChaneged(sender:)),
                                   for: .valueChanged)
        
        let barHight: CGFloat = self.navigationController?.navigationBar.frame.size.height ?? 0
        let segmentedPositioonX = showHotScrollView.frame.size.height
        
        
        segmentedControl.frame = CGRect(x: 0,
                                        y: segmentedPositioonX + barHight,
                                        width: fullSize.width,
                                        height: 30)
        
        
        self.view.addSubview(segmentedControl)
        
        
        
    }
    
    @objc func onSegmentedControlChaneged(sender: UISegmentedControl){
        
        print(sender.selectedSegmentIndex)
        
        print(sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "nothing")
        
        
    }
    
    /**
     Put some image in here
     */
    fileprivate func addImageOnScrollView(){
        
//        var imageListArray = [UIImage]()
//
//        for imageName in 0...3{
//
//            imageListArray.append(UIImage(named: "\(imageName).jpg")!)
//
//        }
//
//        self.hotImageView.animationImages = imageListArray
//        self.hotImageView.animationDuration = 2.0
//        self.hotImageView.startAnimating()
//
//        showHotScrollView.addSubview(hotImageView)
        
        
        
        //MARK: - Add some view on scrolView
        let photoOne = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: showHotScrollView.frame.size.width,
                                            height: showHotScrollView.frame.size.height))
        photoOne.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)

        showHotScrollView.addSubview(photoOne)
        // add two

        let photoTwo = UIView(frame: CGRect(x: showHotScrollView.frame.size.width,
                                            y: 0,
                                            width: showHotScrollView.frame.size.width,
                                            height: showHotScrollView.frame.size.height))
        photoTwo.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        showHotScrollView.addSubview(photoTwo)
        // add three

        let photoThree = UIView(frame: CGRect(x: showHotScrollView.frame.size.width*2,
                                              y: 0,
                                              width: showHotScrollView.frame.size.width,
                                              height: showHotScrollView.frame.size.height))
        photoThree.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        showHotScrollView.addSubview(photoThree)

        
        //image parameter
        let imageWidth = showHotScrollView.frame.size.width
        let imageHeight = showHotScrollView.frame.size.height
        let positionX: CGFloat = 0
        let positionY: CGFloat = 0
        
        //Test For put imageView on UIView
        let imageOne = UIImageView(image: UIImage(named: "0.jpg"))
        
        imageOne.frame.size.width = imageWidth
        imageOne.frame.size.height = imageHeight
        imageOne.frame.origin.x = positionX
        imageOne.frame.origin.y = positionY
        
        photoOne.addSubview(imageOne)
        
        let imageTwo = UIImageView(image: UIImage(named: "1.jpg"))
        
        imageTwo.frame.size.width = imageWidth
        imageTwo.frame.size.height = imageHeight
        imageTwo.frame.origin.x = positionX
        imageTwo.frame.origin.y = positionY
        
        photoTwo.addSubview(imageTwo)
        
        let imageThree = UIImageView(image: UIImage(named: "2.jpg"))
        
        imageThree.frame.size.width = imageWidth
        imageThree.frame.size.height = imageHeight
        imageThree.frame.origin.x = positionX
        imageThree.frame.origin.y = positionY
        
        photoThree.addSubview(imageThree)
        
    }
    
    
    
    /**
     This method is ScrollView setting.
     */
    fileprivate func settingTheScrollView(){
        
//        guard let barHeight = navigationController?.navigationBar.frame.size.height else { return }
        
//        let searchHeight = searchController.accessibilityFrame.height
        
        let hightS = (self.view.frame.height - self.view.safeAreaLayoutGuide.layoutFrame.height)/2
        
        showHotScrollView = UIScrollView(frame: CGRect(x: 0,
                                                       y: hightS,
                                                       width: fullSize.width,
                                                       height: fullSize.height/3))
        showHotScrollView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        showHotScrollView.contentSize = CGSize(width: fullSize.width*5,
                                               height: (fullSize.height/3))
        
        showHotScrollView.delegate = self
        //Once paging to show
        showHotScrollView.isPagingEnabled = true
        //Once one direction to scroll
        showHotScrollView.isDirectionalLockEnabled = true
        showHotScrollView.showsVerticalScrollIndicator = false
        showHotScrollView.showsHorizontalScrollIndicator = false
//        showHotScrollView.scrollsToTop = false
        
        self.view.addSubview(showHotScrollView)
        
    }
    
    
    /**
     This method is pageControl setting, you can change the **Rect** and **center** **numberOfPage** , and set **target** here .
     - Returns: return a pageControl with setting end.
     */
    fileprivate func settingThePageControl() {
        
        pageControl = UIPageControl(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: fullSize.width*0.85,
                                                  height: 50))
        
        pageControl.center = CGPoint(x: fullSize.width*0.5,
                                     y: showHotScrollView.frame.size.height*0.95)
        
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.gray
//
//        pageControl.addTarget(ViewController.self,
//                              action: #selector(pageChanged(sender:)),
//                              for: .touchUpInside)
        
        self.view.addSubview(pageControl)
       
    }
    
    @objc func pageChanged(sender : UIPageControl){
        
        var frame = showHotScrollView.frame
        frame.origin.x = frame.size.width*CGFloat(sender.currentPage)
        frame.origin.y = 0
        showHotScrollView.scrollRectToVisible(frame, animated: true)
        
    }
    
    
    fileprivate func createShowPageLabel(){
        var myLabel = UILabel()
        
        for i in 0..<5 {
            myLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullSize.width*0.5, height: 40))
            
            myLabel.center = CGPoint(x: fullSize.width*(0.5+CGFloat(i)),
                                     y: showHotScrollView.frame.height*0.8)
            
            myLabel.font = UIFont(name: "Helvetica-Light", size: 30)
            
            myLabel.textAlignment = .center
            myLabel.text = "This is \(i+1)"
            
            showHotScrollView.addSubview(myLabel)
        }
        
    }

    /**
     This is some code.
     
     - Parameter firstThing: called name
     - Parameter secondThing: called date
     - Returns: mean the full name .
     - Todo: Support middle name in the next version.
     
     */
    fileprivate func testForMarkDown(firstThing: String , secondThing: String) -> Void {
        //TODO: - Support middle name in the next version.
        print("Test one two three")
    }
    
}

extension ViewController : UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        
        pageControl.currentPage = page
        
    }
    
}
