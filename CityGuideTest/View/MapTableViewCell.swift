//
//  MapTableViewCell.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/15.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class MapTableViewCell: UITableViewCell {

//    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareForGMSView()
    }

    func prepareForGMSView(){
        
        let mapData = saveInfoStruct.getMapNeedsData()
        let title = mapData.0
        let address = mapData.1
        let lat = mapData.2[0]
        let lon = mapData.2[1]
        
        // coordinate -33.86,151.20 at zoom level 6. 25.042775,121.5319796
        //CGRect(x: 0, y: 0, width: mapView.frame.width, height: mapView.frame.height)
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(lat),
                                              longitude: CLLocationDegrees(lon), zoom: 15.0)
        let gmsView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: mapView.bounds.width, height: mapView.bounds.height), camera: camera)
        
        gmsView.isMyLocationEnabled = true
//        view = mapView
        
        self.mapView.addSubview(gmsView)//Important must use addSubview.
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat),
                                                 longitude: CLLocationDegrees(lon))
        
        marker.appearAnimation = .pop
        
        marker.title = title //Name
        marker.snippet = address //Address
        marker.map = gmsView
        print("It on cell setup ")
        gmsView.selectedMarker = marker
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
