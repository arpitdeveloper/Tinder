//
//  ChatViewCell.swift
//  Tinder
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit

class ChatViewCell: UITableViewCell {

    @IBOutlet var emaillbl: UILabel!
    @IBOutlet var namelbl: UILabel!
    @IBOutlet var imgIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
