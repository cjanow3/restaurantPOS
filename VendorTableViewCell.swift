//
//  VendorTableViewCell.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/20/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class VendorTableViewCell: UITableViewCell {

    @IBOutlet weak var vendorName: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
