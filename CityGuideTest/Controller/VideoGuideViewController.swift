//
//  VeidoGuideViewController.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/30.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoGuideViewController: UIViewController,YouTubePlayerDelegate {

     let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      self.youtubePlayerView.delegate = self
        
//        addIndicatorView(activityIndicator: activityIndicator, superView: self.view)
        
        // Initialization code
        let youtubeIDs = saveInfoStruct.youtubeID
        if youtubeIDs.count != 0 {
            print("youtubeID: \(youtubeIDs)")
            youtubePlayerView.loadVideoID(youtubeIDs[0])
        }else {
            print("It's no youtubeID .")
            youtubePlayerView.removeFromSuperview()
            let coverView =  UIImageView(image: UIImage(named: "placeholder.png"))
            let viewBounds = self.view.bounds
            coverView.frame = viewBounds
            
            let label = UILabel(frame:CGRect(x: 0, y: 0, width: viewBounds.width/2, height: 40))
            label.numberOfLines = 2
            label.text = "很抱歉，此景點暫無提供導覽影片。"
            label.textColor = .white
            label.shadowColor = .black
            label.shadowOffset = CGSize(width: 1.5, height: 1.5)
            coverView.addSubview(label)
            prepareForConstraits(item: label, superView: coverView)
            self.view.addSubview(coverView)
            
            
        }
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.hideTabBarAnimated(hide: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.hideTabBarAnimated(hide: false)
    }
    

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
  
      
        
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        print("PlayerReady 是否ＯＫ")
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
    }
    
    func prepareForConstraits(item: AnyObject,superView: AnyObject?){
        guard let label = item as? UILabel,
        let coverView = superView as? UIImageView
        else {
            return
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: label,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: coverView,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 100)
        coverView.addConstraint(topConstraint)
        
        //Test for the constraint by programing.
//        let leadingConstraint = NSLayoutConstraint(item: label,
//                                                   attribute: .leading,
//                                                   relatedBy: .equal,
//                                                   toItem: coverView,
//                                                   attribute: .leading,
//                                                   multiplier: 1,
//                                                   constant: 100)
//        coverView.addConstraint(leadingConstraint)
        
        //right constraint.
//        let trailingConstraint = NSLayoutConstraint(item: label,
//                                                   attribute: .trailing,
//                                                   relatedBy: .equal,
//                                                   toItem: coverView,
//                                                   attribute: .trailing,
//                                                   multiplier: 1,
//                                                   constant: 0)
//        coverView.addConstraint(trailingConstraint)
        
        let centerXConstraint = NSLayoutConstraint(item: label,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: coverView,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0)
        coverView.addConstraint(centerXConstraint)
        
    }
    
    func addIndicatorView(activityIndicator: UIActivityIndicatorView, superView: UIView){
        
        //        self.typeListTableView.addSubview(activityIndicator)
        superView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
//        activityIndicator.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
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
//        let leadingConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
//        view.addConstraint(leadingConstraint)
//
//        activityIndicator.startAnimating()
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
