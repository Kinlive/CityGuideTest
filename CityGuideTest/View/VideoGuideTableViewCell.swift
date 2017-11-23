//
//  VideoGuideTableViewCell.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/15.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoGuideTableViewCell: UITableViewCell,YouTubePlayerDelegate {

    @IBOutlet weak var youtubeView: YouTubePlayerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let youtubeID = saveInfoStruct.youtubeID {
            print("youtubeID: \(youtubeID)")
            youtubeView.loadVideoID(youtubeID)
        }else {
            print("It's no youtubeID .")
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
