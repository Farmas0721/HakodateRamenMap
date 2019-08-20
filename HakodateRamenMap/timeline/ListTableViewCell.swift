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
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var ramenphoto: UIImageView!
    @IBOutlet weak var hooterView: UIView!
    @IBOutlet weak var date: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        content.font = UIFont.systemFont(ofSize: 24)
        content.textColor = UIColor.white
        date.textColor = UIColor.white
        hooterView.backgroundColor = .orange
        // Configure the view for the selected state
    }
    
    func setPhotoImage(image: UIImage){
        self.ramenphoto.image = image
    }
}
