//
//  PanoViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/16.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit
import GoogleMaps
import WebKit

class PanoViewController: UIViewController,WKNavigationDelegate,GMSMapViewDelegate,GMSPanoramaViewDelegate {

    @IBOutlet weak var panoramaView: UIView!
    @IBOutlet weak var guideMapView: UIView!
    
    @IBOutlet weak var tapBtnOut: UIButton!
    var tapStatus = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnHeight = tapBtnOut.frame.height
        let mapHeight = guideMapView.frame.height
        guideMapView.transform = CGAffineTransform(scaleX: 0, y: mapHeight - btnHeight)
        
        //Prepare the latLon and hori, verti.
        if let mapUrlStr = saveInfoStruct.mapPanoUrl {
            
            let allNeeds = separatePanoramaURL(urlStr: mapUrlStr)
            
            //        print("URl: \(saveInfoStruct.mapPanoUrl),allNeeds 0:\(allNeeds.0),1:\(allNeeds.1),2:\(allNeeds.2),3:\(allNeeds.3)")
            if let lat = Double(allNeeds.0),
                let lon = Double(allNeeds.1),
                let horizontal = Double(allNeeds.2),
                let _ = Double(allNeeds.3){
                
                let panoView = GMSPanoramaView(frame: CGRect.zero)
                self.view = panoView
                
                panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon)))
                
                let camera = GMSPanoramaCamera(heading: CLLocationDirection(horizontal), pitch: 0, zoom: 1)
                panoView.camera = camera
                panoView.delegate = self
                print("Lat:\(lat) Lon:\(lon)")
                
            }else{
                print("Not catch the allNeeds data.")
            }
        }
        
    
        
//        let mapData = saveInfoStruct.getMapNeedsData()
//
//        let lat = mapData.2[0]
//        let lon = mapData.2[1]
        
        
//        let latTest: Float = 22.677//009//
//        let lonTest: Float = 121.485//9//89//00000002
        
        //Test for guidepath position
//        let latGuidePo: Float = 25.0343355
//        let lonGuidePo: Float = 121.5639284
        
//        let latTest: Float = 22.6768957 //房子裡, 網址給的
//        let lonTest: Float = 121.4860164
        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
//        panoramaView.removeFromSuperview()
    }
  
    @IBAction func tapButton(_ sender: UIButton) {
        
        let mapHeight = guideMapView.frame.height
        let btnHeight = tapBtnOut.frame.height
        if tapStatus == 0{
            
            UIView.animate(withDuration: 0.5, animations: {
                self.guideMapView.transform = CGAffineTransform(scaleX: 0, y: 0)
            })
            
            
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.guideMapView.transform = CGAffineTransform(scaleX: 0, y: mapHeight - btnHeight)
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
