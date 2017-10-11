//
//  driverOrdersTableViewCell.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 9/1/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class driverOrdersTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var custName: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var total: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
