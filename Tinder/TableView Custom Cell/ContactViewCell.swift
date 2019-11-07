//
//  ContactViewCell.swift
//  Tinder
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {

    @IBOutlet var imageIV: UIImageView!
    @IBOutlet var emailLBL: UILabel!
    @IBOutlet var nameLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageIV.layer.cornerRadius = self.imageIV.bounds.size.height/1.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
