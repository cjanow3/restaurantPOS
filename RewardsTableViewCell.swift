//
//  RewardsTableViewCell.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 11/12/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class RewardsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
