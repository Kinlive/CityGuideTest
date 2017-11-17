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

    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
//    @IBOutlet weak var panoramaView: GMSPanoramaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let mapData = saveInfoStruct.getMapNeedsData()
    
        let lat = mapData.2[0]
        let lon = mapData.2[1]
        let latTest: Double = 25.045135
        let lonTest: Double = 121.529585
        let panoView = GMSPanoramaView(frame: CGRect.zero)
        self.view = panoView
        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: latTest, longitude: lonTest))
        
        panoView.delegate = self
        print("Lat:\(lat) Lon:\(lon)")
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
//        panoramaView.removeFromSuperview()
    }
  
    

    

//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6. 25.042775,121.5319796
//        let camera = GMSCameraPosition.camera(withLatitude: 25.042775,
//                                              longitude: 121.5319796, zoom: 15.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        mapView.isMyLocationEnabled = true
//        view = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 25.042775,
//                                                 longitude: 121.5319796)
//        marker.title = "Test"
//        marker.snippet = "Test detail"
//        marker.map = mapView
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveToPanoramaID panoramaID: String) {
        
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
