//
//  driverTotalTableViewCell.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 8/22/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class driverTotalTableViewCell: UITableViewCell {

    @IBOutlet weak var totalDeliveryFee: UILabel!
    
    @IBOutlet weak var totalTip: UILabel!
    
    @IBOutlet weak var totalDifference: UILabel!
    
    @IBOutlet weak var totalEarned: UILabel!
    
    @IBOutlet weak var whoPays: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
