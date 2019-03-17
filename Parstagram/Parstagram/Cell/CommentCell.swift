//
//  CommentCell.swift
//  Parstagram
//
//  Created by Kurtis Hoang on 3/13/19.
//  Copyright © 2019 Kurtis Hoang. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell
{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = 15.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //configure the view for the selected state
        
    }
}
