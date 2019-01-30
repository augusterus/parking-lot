//
//  ParkingListCell.swift
//  Parking
//
//  Created by 王鴻翔 on 2019/1/28.
//  Copyright © 2019 王鴻翔. All rights reserved.
//

import UIKit

class ParkingListCell: UITableViewCell {

    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var lbServiceTime: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    var parking: Parking? {
        didSet {
            if let data = parking {
                lbArea.text = data.area
                lbServiceTime.text = data.servicetime
                lbAddress.text = data.address
                lbName.text = data.name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
