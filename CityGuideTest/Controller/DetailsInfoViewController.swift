//
//  DetailsInfoViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/13.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class DetailsInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate {

    let sectionTitle = ["AR體驗","Detail","Map","Video Guide"]
    
    var codeHeaderView = UIView() //no use now, define by code
    
    //Prepare for this page use.
    var imageName: String?
    var titleName: String?
    var itemSummary: String?
    var itemCoordinateStr: String?
    var itemAddress: String?

    
    //For map use
    var coordin = [Float]()
    var region = MKCoordinateRegion()
    var annotation = MKPointAnnotation()
    
    var gmsMapView = GMSMapView()
    
    @IBOutlet weak var cellsMapView: UIView!
    //    var indexPaths = [IndexPath]()
//    @IBOutlet weak var heightConstraint: NSLayoutConstraint!{
//        didSet{
//            heightConstraint.constant = maxHeight
//        }
//    }
//    let maxHeight: CGFloat = 250.0
//    let minHeight: CGFloat = 50.0
    
    @IBOutlet weak var headerContentView: UIView!
    @IBOutlet weak var titleImg: UIImageView!
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailsInfoTableView: UITableView!{
        didSet{//從這裡修改解決header卡住的問題
//            detailsInfoTableView.contentInset = UIEdgeInsets(top: maxHeight, left: 0, bottom: 0, right: 0)
            
            
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsInfoTableView.delegate = self
        detailsInfoTableView.dataSource = self
        
//        prepareForHeaderTitle()
        
        
        detailsInfoTableView.estimatedRowHeight = 300
        detailsInfoTableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
//        saveInfoStruct.resetMapData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        prepareForHeaderTitle()
        print("ViewWillAppear")

    }
    
    
    //MARK: - Prepare for header title data.
    func prepareForHeaderTitle() {
        
        guard
            let segmentTitle = saveInfoStruct.getWhichSegmentedTitle(),
            let selectedIndexPath = saveInfoStruct.getSelectedIndexPath()
            else {return }
        
        
        switch  segmentTitle {
        case .cities:
            //Prepare for cacheKey get.
            let cityObject = cityDetailListModel.cityDetailList[selectedIndexPath.row]
            
            imageName = cityObject.img[0]
            titleName = cityObject.name
            itemSummary = cityObject.content == "" ?cityObject.summary:cityObject.content
            itemCoordinateStr = cityObject.map
            itemAddress = cityObject.address
            saveInfoStruct.mapPanoUrl = cityObject.panorama
            
            
        case .types:
            let typeObject = typeDetailListModel.typeDetailList[selectedIndexPath.row]
            imageName = typeObject.img[0]
            titleName = typeObject.name
            itemSummary = typeObject.content == "" ?typeObject.summary:typeObject.content
            itemCoordinateStr = typeObject.map
            itemAddress = typeObject.address
            saveInfoStruct.mapPanoUrl = typeObject.panorama
        case .brands:

            let brandObject = brandDetailListModel.brandDetailList[selectedIndexPath.row]
            imageName = brandObject.img[0]
            titleName = brandObject.name
            itemSummary = brandObject.content == "" ?brandObject.summary:brandObject.content
            itemCoordinateStr = brandObject.map
            itemAddress = brandObject.address
            saveInfoStruct.mapPanoUrl = brandObject.panorama
        }
        
        guard
            let imgName = imageName,
            let title = titleName else {return }
        
        let cacheKey = "\(segmentTitle)\(imgName)"
       
        //Get image with cacheKey.
        guard let img = getImgWith(cacheKey: cacheKey) else {return}
        
        
        self.titelLabel.text = title
        self.titleImg.image = img
//        setTableHeaderView(image: img, titleStr: title)
        
        print("This is cache key\(cacheKey)")
        prepareRegion()
        
//        prepareMapAnnotation()
//        prepareGMS()
        
        
    }
    
    
    
    //MARK: - Prepare for map use
    func prepareRegion() {
        //Reset some data
        saveInfoStruct.resetMapData()
        coordin.removeAll()
        
        if let coorStr = itemCoordinateStr {
            let coorArray = coorStr.split(separator: ",")
            for (_,coor) in coorArray.enumerated(){
                
                print("This is ======coor:\(coor)")
                if let coorDouble = Float(coor){
                    coordin.append(coorDouble)
                }
                //                print("Test for coordinate: \(index) : \(coor)")
            }
            
        }
        
        //prepare for map data save.
        guard
            let titleName = self.titleName,
            let itemAddress = self.itemAddress
            else{
                return
        }
        print("This MapDataForSave: \(titleName),\(coordin)")
        saveInfoStruct.saveInfoOfMap(title: titleName, address: itemAddress, coordinate: coordin)
        
        //        region.center = CLLocationCoordinate2D(latitude: coordin[0], longitude: coordin[1])
        //        region.span = MKCoordinateSpanMake(0.005, 0.005)
        
        
    }
    
    
    
    //MARK: - Prepare for google maps. no use
    func prepareGMS(){
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: region.center.latitude,
                                              longitude: region.center.longitude, zoom: 15.0)
        gmsMapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        gmsMapView.isMyLocationEnabled = true
//        gmsMapView = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
        marker.title = titleName
        marker.snippet = itemAddress
        marker.map = gmsMapView
    }
    
    
    //MARK: - Setup the Table HeaderView , no use now.
    /**
     Setup the tableView's headerView with **imageView** and **label** and **button**.
     - Parameter image: Set the title image.
     - Parameter titleStr: Set title text.
     */
    func setTableHeaderView(image: UIImage, titleStr: String){
        
        codeHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: detailsInfoTableView.frame.width, height: 250))
        //Prepare for subView's frame.
        let viewWidth = codeHeaderView.frame.width
        let viewHeight = codeHeaderView.frame.height
        
        //Setup the imageView
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        imgView.image = image
        codeHeaderView.addSubview(imgView)
        
        //Setup the label
        let label = UILabel(frame: CGRect(x: 8, y: 8, width: viewWidth/2, height: 60))
        
        label.font = UIFont(name: "Helvetica-Bold", size: 40)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.textAlignment = .left
        label.numberOfLines = 0
        label.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.text = titleStr
        codeHeaderView.addSubview(label)
        
        //Setup the button
        let button = UIButton()
        let btnPositionX = viewWidth*2/3 - 8
        let btnPositionY = viewHeight*2/3 - 8
        button.frame = CGRect(x: btnPositionX, y: btnPositionY, width: viewWidth/3, height: 40)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.2979461551, blue: 0.399777323, alpha: 1)
        button.setTitle("360°", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .normal)
        codeHeaderView.addSubview(button)
        
        detailsInfoTableView.tableHeaderView = codeHeaderView
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
        return sectionTitle.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            
            print("To get section ")
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if indexPath.section == 2{
//            return 200
//        }
//        return 50
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        //AR cell
        if indexPath.section == 0,
            let cell = tableView.dequeueReusableCell(withIdentifier: "arButtonCell") as? ARButtonTableViewCell {
            tableView.rowHeight = UITableViewAutomaticDimension
            
           return cell
        }
        
        //Detail content cell
        if indexPath.section == 1,
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderCell") as? DetailsInfoTableViewCell,
            let summary = itemSummary {
            
            cell.detailTitleLabel.text = ""
            cell.textLabel?.text = summary
            cell.textLabel?.numberOfLines = 0
            tableView.rowHeight = UITableViewAutomaticDimension
            
            return cell
        }
      
        //Map cell
        if indexPath.section == 2,
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell") as? MapTableViewCell{
            print("It on cell init")
            tableView.rowHeight = 400
            
            
//            cell.mapView.addSubview(gmsMapView)
            
//            cell.mapView.delegate = self
//            cell.mapView.region = region
//            cell.mapView.addAnnotation(annotation)
          
//            let customView = UIView()
//
//            customView.backgroundColor = .white
//            cell.selectedBackgroundView = customView
            
            return cell
        }
        
        //Video guide cell
        if indexPath.section == 3,
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoGuideCell") as? VideoGuideTableViewCell{
            
            cell.textLabel?.text = "I am a Video Guide"
            tableView.rowHeight = UITableViewAutomaticDimension
            return cell
            
        }
        

        let cell = tableView.cellForRow(at: indexPath)
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        let label = UILabel()
        label.frame = CGRect(x: 5, y: 5, width: tableView.frame.width, height: 50)
        label.textAlignment = .center
        label.text = sectionTitle[section]
        view.addSubview(label)
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }


  
    
    
    //MARK: - The func no use now.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoId = "CityGuideAnno"
        
        let result = mapView.dequeueReusableAnnotationView(withIdentifier: annoId) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: annoId)
        
        result.annotation = annotation
        result.canShowCallout = true
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        btn.setTitle("GO!!", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
      
        result.leftCalloutAccessoryView = btn
        
        print("是否有自動進入annotation the delegate 方法")
        return result
    }
    
    func prepareMapAnnotation(){
        
        if let title = titleName,
            let address = itemAddress {
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(coordin[0]), longitude: CLLocationDegrees(coordin[1]))
            annotation.title = title
            annotation.subtitle = address
            
            
        }
    }
   
    //MARK: - Resize the contentEntryView when scrolling
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//
//        if scrollView.contentOffset.y < 0{ //swipe down , seeing top page.
//            headerHeightConstraint.constant = max(fabs(scrollView.contentOffset.y), minHeight)
//
////            headerContentView.frame.size.height = currentHeight
//
//
//        }else{//swipe top , seeing bottom page.
//
////                headerContentView.frame.size.height = minHeight
//            headerHeightConstraint.constant = minHeight
//
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



