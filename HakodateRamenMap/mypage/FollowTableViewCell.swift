//
//  TableViewCell.swift
//  HakodateRamenMap
//
//  Created by 中村　朝陽 on 2019/06/04.
//  Copyright © 2019 asahi. All rights reserved.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.adjustsFontSizeToFitWidth = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
