//
//  GardensTableViewCell.swift
//  InstaGreen
//
//  Created by Madushani Lekam Wasam Liyanage on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class GardensTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gardenNameLabel: UILabel!
    
    @IBOutlet weak var gardenAddressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func directionsButtonTapped(_ sender: UIButton) {
        
        
    }
}
