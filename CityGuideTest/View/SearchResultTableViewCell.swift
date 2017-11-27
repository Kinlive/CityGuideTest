//
//  SearchResultTableViewCell.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/24.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    @IBOutlet weak var resultTitle: UILabel!
    
    @IBOutlet weak var resultDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
