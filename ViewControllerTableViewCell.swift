//
//  ViewControllerTableViewCell.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 5/17/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    //labels used in each cell in table view
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderPickupDelivery: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderVendor: UILabel!


    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
