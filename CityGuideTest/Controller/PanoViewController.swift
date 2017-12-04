//
//  PanoViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/16.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit
import GoogleMaps


class PanoViewController: UIViewController,GMSMapViewDelegate,GMSPanoramaViewDelegate {

    let communicator = Communicator()
    let downloadImgQueue = OperationQueue()
    
    let firstGuidePoints = ["25.04396,121.52952200000004","25.044561,121.52974300000005","25.043762,121.52936899999997","25.044304,121.52897899999994"]
    var guidePoints: [(Double,Double)] = []
    
    //For guideMapImage
    let guideMapName = saveInfoStruct.guideMapImageName

    var imageNumber = 0 //for guideMap count use.
    var guideMapImagesTest: [String:UIImage] = [:]{
        didSet{
            if guideMapImagesTest.count == 0{
                guideMapImageView.image = UIImage(named: "placeholder.png")
//                print("GUIDE MAP Images count == 0")
            }else{
                let whichImageKey = guideMapName[imageNumber]
                guideMapImageView.image = guideMapImagesTest[whichImageKey]
                
                
                
//                print("Look LOOK imgView size \(whichImageKey)'s WIDTH: \(guideMapImageView.image?.size.width) HEIGHT:\(guideMapImageView.image?.size.height)")
//                print("GUIDE MAP Images count != 0")
               
            }
        }
    }
    
    
    
    //For guideMap pano btn use.
    var btnArrays: [UIButton] = []
    
    var guidePoint: [(Double,Double)] = []
    
    var guideMapPosition: [(CGFloat, CGFloat)] = []{
        didSet{
            
            for btn in btnArrays{
                btn.removeFromSuperview()
            }
            
            for (index,position) in guideMapPosition.enumerated(){
             
                OperationQueue.main.addOperation {
                    let btn = UIButton()
                    btn.frame = CGRect(x: position.0, y: position.1, width: 30, height: 30)
                    btn.setTitle("\(index + 1)", for: .normal)
                    btn.tag = index
                    btn.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    btn.addTarget(self, action: #selector(self.guidePointsBtnPress(sender:)), for: .touchUpInside)
                    self.btnArrays.append(btn)
                    
                    self.guideMapImageView.addSubview(btn)
                }
                
            }
        }
    }
    
    
    
    //For guideMapView frame
    var btnHeight: CGFloat = 0
    var mapHeight: CGFloat = 0
    
    @IBOutlet weak var panoramaView: GMSPanoramaView!
    @IBOutlet weak var guideMapView: UIView!
    
    @IBOutlet weak var tapBtnOut: UIButton!
    @IBOutlet weak var guideMapImageView: UIImageView!
    
    @IBOutlet weak var floorBtnBgView: UIView!
    
    
    var tapStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
        if let titleName = saveInfoStruct.getMapNeedsData().0 {
            self.navigationItem.title = titleName
        }
        
        btnHeight = self.tapBtnOut.bounds.height
        mapHeight = self.guideMapView.bounds.height
        
        
        prepareForGuidePoints(points: firstGuidePoints)
        
//        self.guideMapImageView.image = UIImage(named: "placeholder.png")
        prepareForGuideMapImageDownload()

        self.guideMapView.transform = CGAffineTransform(translationX: 0, y: mapHeight - btnHeight)
        
//        prepareForPanoramaView()
        newprepareForPanoramaView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.hideTabBarAnimated(hide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
        self.tabBarController?.hideTabBarAnimated(hide: false)
//        panoramaView.removeFromSuperview()
    }
  
    
    func prepareForGuideMapDataDownload(){
        
        
        
    }
    
    //MARK: - Prepare for guideMap image download
    func prepareForGuideMapImageDownload(){
        
        //prepare for the guideMap img download.
       
        if guideMapName.count != 0{
            saveInfoStruct.guideMapNames = guideMapName
            
            for (index,imageName) in guideMapName.enumerated(){
                //Request for get guideMap object.
                let guideMapUrl = "\(ICLICK_URL)\(GET_GUIDEMAPOBJECT_URL)\(imageName)"
                print("GUIDEMAP========URL\(index)\(index)\(index):\(guideMapUrl)")
                downloadImgQueue.addOperation {
                    self.communicator.connectToServer(urlStr: guideMapUrl, whichApiGet: WhichAPIGet.guideMapObject, completion: { (success) in
                        //Get the guideMapObject.index pass to init btn
                        //and pass imgName to btn.
                        if success {
                            OperationQueue.main.addOperation {
                                self.prepareForGuideMapFloor(tag: index, imgName: imageName)
                                
                                /////////
                                let imageUrl = "\(ICLICK_URL)\(GET_PLACEIMG_URL)\(imageName)"
                                
                                self.downloadImgQueue.addOperation {
                                    //Image url change to GET_PLACEIMG_URL with GET_COMPRESS_IMG
                                    self.downloadImgQueueMethod(imageUrlStr: imageUrl, completion: { (success, img) in
                                        if success,
                                            let finalImg = img{
                                            OperationQueue.main.addOperation {
                                                
                                                //Add the img to dictionary.
                                                self.guideMapImagesTest[imageName] = finalImg
                                                //Prepare the scale for panorama's point.
                                                
                                                if index == 0 {
                                                    
                                                    self.prepareImgScaleForPano(finalImg: finalImg, imageName: imageName)
                                                    
                                                }
                                                
                                                
                                            }
                                        }
                                    })
                                    
                                    
                                }
                                
                                
                                
                                ////////
                            }
                        }
                    })
                }
                
//                print("imageURL: \(imageUrl)")
//                print("GuideMapName:\(guideMapName)")
                
                
                
            }
            
        }else{
            guideMapImageView.image = UIImage(named: "placeholder.png")
            print("GuideMap array is EMPTY.")
        }
    }
    
    
    //MARK: - Prepare for guide map floor change btn
    func prepareForGuideMapFloor(tag: Int, imgName: String){
        
        let btnPositionY: CGFloat = 0
        
        let floorBtnWidth = tapBtnOut.bounds.width/1.2
        let floorBtnHeight = tapBtnOut.bounds.height
        
        let btnPositionX: CGFloat = floorBtnWidth*CGFloat(tag) + 1
        
//        for (index,imgName) in guideMapName.enumerated(){
            if let guideMapObj = guideMapModel.guideMapObjectList[imgName]{
             
                let floorBtn = UIButton()
                floorBtn.setTitle("\(guideMapObj.title)", for: .normal)
                floorBtn.frame = CGRect(x: btnPositionX, y: btnPositionY, width: floorBtnWidth, height: floorBtnHeight)
                floorBtn.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                floorBtn.tag = tag
                floorBtn.addTarget(self, action: #selector(floorBtnPress(sender:)), for: .touchUpInside)
                floorBtnBgView.addSubview(floorBtn)
                //            btnPositionY -= btnHeight - 1
                //            btnPositionY += btnHeight + 1
//                btnPositionX = floorBtnWidth*CGFloat(tag) + 1
                
            }
//        }
       
        
    }
    
    //MARK: - Prepare the image scale for pano point use.
    func prepareImgScaleForPano(finalImg: UIImage, imageName: String){
        
        //All prepare for point btn.
        
//        let imgViewWidth = self.guideMapImageView.frame.width
//        let imgViewHeight = self.guideMapImageView.frame.height
        
        //                            self.guideMapImages.append(finalImg)
        if let guideMapObject = guideMapModel.guideMapObjectList[imageName]{
//            let oldImgWidth = finalImg.size.width
//            let oldImgHeight = finalImg.size.height
            
            let newWidthScale: CGFloat = 0.9 //imgViewWidth/oldImgWidth
            let newHeightScale: CGFloat = 0.95 //imgViewHeight/oldImgHeight
//            print("SCALESCALESCALE:\(newWidthScale),,\(newHeightScale)")
            
            var newPositions: [(CGFloat,CGFloat)] = []
            for (_, location) in guideMapObject.location.enumerated(){
                //Init the point btn.
                let newPosiX = CGFloat(location.x) * newWidthScale
                let newPosiY = CGFloat(location.y) * newHeightScale
//                print("LocationX:\(location.x) , Y: \(location.y) fixedX: \(newPosiX) and Y:\(newPosiY)")
                let newPosi = (newPosiX, newPosiY)
                
                print("NewPosiX and Y : \(newPosi)")
                newPositions.append(newPosi)
                
            }
            
            self.guideMapPosition = newPositions
        }else{
            print("NOT GET the guideMapObject...............7777777")
        }
        
    }
    
    
    //MARK: - Button target func.
    @objc func floorBtnPress(sender: UIButton){
        imageNumber = sender.tag
        let selectGuideImgName = guideMapName[imageNumber]
        self.guideMapImageView.image = guideMapImagesTest[selectGuideImgName]
        
        prepareImgScaleForPano(finalImg: guideMapImagesTest[selectGuideImgName]!,
                               imageName: selectGuideImgName)
        
        
        
    }
    //MARK: - Button target func for guide points.
    @objc func guidePointsBtnPress(sender: UIButton){
        
        
    }
    
    ///MARK: - Prepare for guide point
    func prepareForGuidePoints(points: [String]){
        
        for point in points{
            
            let splitPoint = point.split(separator: ",")
           
//            for (i,pp) in splitPoint.enumerated(){
            
            

//                print("GuidePoint split index:\(i) and point: \(pp)")
                if
                    let lat = Double(splitPoint[0]),
                    let lon = Double(splitPoint[1]){
                    let touple = (lat,lon)
//                    print("Test For Touple : \(touple)")
                    guidePoints.append(touple)
                }else {
                    print("SplitPoint fail: \(splitPoint)")

                }
//            }
        }
        
//        print("Test for guidePoints: \(guidePoints)")
    }
    
    func prepareForPanoramaView(){
        
        //Prepare the latLon and hori, verti.
        if let mapUrlStr = saveInfoStruct.mapPanoUrl {
            
            let allNeeds = separatePanoramaURL(urlStr: mapUrlStr)
            
            //        print("URl: \(saveInfoStruct.mapPanoUrl),allNeeds 0:\(allNeeds.0),1:\(allNeeds.1),2:\(allNeeds.2),3:\(allNeeds.3)")
            if let lat = Double(allNeeds.0),
                let lon = Double(allNeeds.1),
                let horizontal = Double(allNeeds.2),
                let _ = Double(allNeeds.3){
                
                //                panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon)))
                self.panoramaView.move(toPanoramaID: "6F0S3yjWeRgAAAQfCX0a9w")

                
                let camera = GMSPanoramaCamera(heading: CLLocationDirection(horizontal), pitch: 0, zoom: 1)
                panoramaView.camera = camera
                panoramaView.delegate = self
                print("Lat:\(lat) Lon:\(lon)")
                
                //                prepareForGuideView()
                
            }else{
                print("Not catch the allNeeds data.")
            }
        }
        
       

    }

    
    func newprepareForPanoramaView(){
        
        //Prepare the pano data.
        if
            let panoData = panoramaModel.panoramaObjectList.first{
        
            let lat = Double(panoData.lat) ?? 0.0
            let lon = Double(panoData.lon) ?? 0.0
            
            let position = panoData.position
            let splitPosi = position.split(separator: ",")
            let posiLat = Double(splitPosi[0]) ?? 0.0
            let posiLon = Double(splitPosi[1]) ?? 0.0
            
            let panoId = panoData.panoId
            
            
            let pitch = panoData.pitch
            let heading = Double(panoData.heading) ?? 0.0
            let zoom = Float(panoData.zoom) ?? 0.0
            
            
            if panoId != "" {//If you look out here, you maybe think the boss had many things of himself. And run away right, because him will very very stick like a limpet with u. It's not kidding!! Trust me you will be fine on your work life.
                
               self.panoramaView.move(toPanoramaID: panoId)
                
            }else if lat != 0.0, lon != 0.0{
                
                self.panoramaView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lon))
                
            }else if posiLat != 0.0, posiLon != 0.0{
                self.panoramaView.moveNearCoordinate(CLLocationCoordinate2D(latitude: posiLat, longitude: posiLon))
            }else{
                createAlertView()
            }
            
            
            
            let camera = GMSPanoramaCamera(heading: CLLocationDirection(heading), pitch: pitch , zoom: zoom)
            panoramaView.camera = camera
            panoramaView.delegate = self
            
            print("Test for the panodata on panoView: \(panoId),\(heading),\(pitch),\(zoom)")
        }else{
            print("NO catch the need data-==-=-=-=-=-=-=-=-=-==-.")
            createAlertView()
        }
        
    }
    
    
    func createAlertView(){
        let alert = UIAlertController(title: "未提供環景功能", message: "這個景點目前暫無360環景功能。", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (ok) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func tapButton(_ sender: UIButton) {
        
        if tapStatus == 0{
            
            UIView.animate(withDuration: 0.5, animations: {
                self.guideMapView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.tapStatus = 1
            })
            
            
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.guideMapView.transform = CGAffineTransform(translationX: 0, y: self.mapHeight - self.btnHeight)
                self.tapStatus = 0
            })
            
        }
        
        
    }
    //MARK: - FOr Test button .
    
    @IBAction func point0(_ sender: UIButton) {
        letMoveThePano(index: 0)
       
//        imageNumber -= 1
//        if imageNumber < 0 {
////            imageNumber = guideMapImages.count - 1
////            self.guideMapImageView.image = guideMapImages[imageNumber]
//            imageNumber = guideMapImagesTest.count - 1
//            let whichImageNameUse = guideMapName[imageNumber]
//            self.guideMapImageView.image = guideMapImagesTest[whichImageNameUse]
//        }else{
////            self.guideMapImageView.image = guideMapImages[imageNumber]
//            let whichImageNameUse = guideMapName[imageNumber]
//            self.guideMapImageView.image = guideMapImagesTest[whichImageNameUse]
//
//        }
//        print("ImageNumber: \(imageNumber)")
    }
    
    @IBAction func point1(_ sender: UIButton) {
        letMoveThePano(index: 1)
        
//        imageNumber += 1
//        if imageNumber <= guideMapImagesTest.count - 1 {
////            <= guideMapImages.count - 1{
//
////            self.guideMapImageView.image = guideMapImages[imageNumber]
//            let whichImageNameUse = guideMapName[imageNumber]
//            self.guideMapImageView.image = guideMapImagesTest[whichImageNameUse]
//
//
//        }else{
//
//            imageNumber = 0
////            self.guideMapImageView.image = guideMapImages[imageNumber]
//
//            let whichImageNameUse = guideMapName[imageNumber]
//            self.guideMapImageView.image = guideMapImagesTest[whichImageNameUse]
//        }
//        print("ImageNumber: \(imageNumber)")
    }
    @IBAction func point2(_ sender: UIButton) {
        letMoveThePano(index: 2)
    }
    @IBAction func point3(_ sender: UIButton) {
        letMoveThePano(index: 3)
        
      
    }
    
    func letMoveThePano(index: Int){
        let lat = guidePoints[index].0
        let lon = guidePoints[index].1
        self.panoramaView.moveNearCoordinate(CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon)))
        
//        let camera = GMSPanoramaCamera(heading: CLLocationDirection(horizontal), pitch: 0, zoom: 1)
//        panoramaView.camera = camera
        
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
    
    
    /**
     Separate the gives url string.
     - Parameter urlStr: This you pass the url string.
     - Returns: Index[0] is **lat**, index[1] is **lon** , index[2] is **horizontal** , index[3] is **vertical**.
     */
    func separatePanoramaURL(urlStr: String) -> (String,String,String,String){
        
        //start index.
        guard let startIndex = urlStr.index(of: "@") else {
            fatalError("StartIndex not found '@'  ")
            //           return nil
        }
        let newStr = urlStr[startIndex...]
        
        guard let endIndex = newStr.index(of: "t") else {
            
            fatalError("EndIndex not found 't' ")
            //            return nil
        }
        
        let secondStr = newStr[...endIndex]
        
        //        print("Test for finalStr: \(finalStr)")
        let splitStr = secondStr.split(separator: ",")
        
        for (index,str) in splitStr.enumerated(){
            print("split:\(index):\(str)")
        }
        
        //Here is I want get index 0(lat) , 1(lon) , 4(horizontal) ,5 (vertical)
        //Separate the lat string.
        
        let firstLat = String(splitStr[0])
        guard let latStartIndex = firstLat.index(of: "@") else {
            fatalError("lat not found the '@' ")
            //            return nil
        }
        
        var lat = String(firstLat[latStartIndex...])
        if let i = lat.index(of: "@") {
            lat.remove(at: i)
        }
        
        let lon = String(splitStr[1])
        
        //Separate the horizontal of "h"
        guard let horizontalEndIndex = splitStr[4].index(of: "h") else {
            fatalError("horizontalEndIndex not found the 'h' ")
            //            return nil
        }
        let horizontalDegree = String(splitStr[4][..<horizontalEndIndex])
        
        //Separate the vertical of "t"
        guard let verticalEndIndex = splitStr[5].index(of: "t") else {
            fatalError("veriticalEndIndex not found the 't' ")
            //            return nil
        }
        let verticalDegree = String(splitStr[5][..<verticalEndIndex])
        
        //        print("This is h and t : \(horizontalDegree) and \(verticalDegree)")
        
        return (lat,lon,horizontalDegree,verticalDegree)
    }


    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - GMSPanoramaView delegate method.
    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveToPanoramaID panoramaID: String) {
        
        
//        print("OnMoveToPanoramaID:\(panoramaID)")
    }
    func panoramaView(_ view: GMSPanoramaView, didMoveTo panorama: GMSPanorama?) {
//        print("DidMoveTo panorama:\(panorama?.coordinate)")
    }
    
    func panoramaView(_ panoramaView: GMSPanoramaView, didMove camera: GMSPanoramaCamera) {
//        print("DidMoveCamera:heading:\(camera.orientation.heading),Pitch:\(camera.orientation.pitch)")
    }
    
    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        
        print(error.localizedDescription)
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
