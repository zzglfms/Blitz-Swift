//
//  UserProfileCell.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/8/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var actionLabel: UILabel!
    var frameAdded = false
    var isCollapsed = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class var expandedHeight: CGFloat { get { return 88 } }
    class var defaultHeight: CGFloat { get { return 44 } }
    
    func checkHeight(){
        titleLabel.hidden = (frame.size.height < UserProfileCell.expandedHeight)
        textfield.hidden = (frame.size.height < UserProfileCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !frameAdded {
            addObserver(self, forKeyPath: "frame", options: .New, context: nil)
            frameAdded = true
        }
    }
    
    func ignoreFrameChanges() {
        if frameAdded {
            removeObserver(self, forKeyPath: "frame")
            frameAdded = false
        }
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    deinit {
        ignoreFrameChanges()
    }
}
