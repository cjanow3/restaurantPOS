//
//  vendorStatsTableViewCell.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 7/27/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class vendorStatsTableViewCell: UITableViewCell {

    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var cash: UILabel!
    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var num: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
