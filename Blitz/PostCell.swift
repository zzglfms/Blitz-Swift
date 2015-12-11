//
//  PostCell.swift
//  Blitz
//
//  Created by ccccccc on 15/10/31.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}