//
//  ListTableViewCell.swift
//  SNSApp
//
//  Created by 山田楓也 on 2019/03/25.
//  Copyright © 2019 Fuuya Yamada. All rights reserved.
//

import UIKit
import FirebaseStorage

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ramenphoto: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
