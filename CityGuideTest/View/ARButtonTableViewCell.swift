//
//  ARButtonTableViewCell.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/15.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class ARButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var arInteractionBtn: UIButton!
    
    @IBOutlet weak var arRouteGuideBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
