//
//  TeamTableViewCell.swift
//  krombopulos-hw6
//
//  Created by Team Krombopulos on 9/23/16.
//  Copyright © 2016 Team Krombopulos. All rights reserved.
//
//  This class is an extension of UITableViewCell as a team table view cell.
//  Contains team label.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    var teamLabel: UILabel!
    var team: Team?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /*
     Sets the selected cell within the table
     
     */
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
