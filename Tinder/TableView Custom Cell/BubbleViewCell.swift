//
//  BubbleViewCell.swift
//  Tinder
//
//  Created by Apple on 20/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit

class BubbleViewCell: UITableViewCell {

    @IBOutlet var userIV: UIImageView!
    @IBOutlet var time2LBL: UILabel!
    @IBOutlet var textLBL: UILabel!
    @IBOutlet var reciverView: UIView!
    @IBOutlet var senderView: UIView!
    @IBOutlet var senderIV: UIImageView!
    @IBOutlet var messageLBL: UILabel!
    @IBOutlet var timeLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
