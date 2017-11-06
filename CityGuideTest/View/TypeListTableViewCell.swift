//
//  TypeListTableViewCell.swift
//  CityGuideTest
//
//  Created by Kinlive on 2017/10/31.
//  Copyright © 2017年 Kinlive Wei. All rights reserved.
//

import UIKit

class TypeListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listImageView: UIImageView!
    
    @IBOutlet weak var listTitle: UILabel!
    
    @IBOutlet weak var listDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
