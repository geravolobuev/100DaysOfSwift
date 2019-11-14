//
//  PictureCell.swift
//  100swift_ConsolidationChallenge5
//
//  Created by MAC on 09/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {
    @IBOutlet var thumbnailCaption: UILabel!
    @IBOutlet var thumbnailPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
