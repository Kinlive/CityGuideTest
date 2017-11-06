//
//  SubSortTableViewCell.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/11/3.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class SubSortTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var subSortImageView: UIImageView!
    
    
    @IBOutlet weak var subSortTitle: UILabel!
    
    @IBOutlet weak var subSortSummery: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
