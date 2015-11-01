//
//  PostCell.swift
//  Blitz
//
//  Created by ccccccc on 15/10/31.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    /* Views */
    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet var DescrLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}