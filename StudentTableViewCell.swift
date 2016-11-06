//
//  StudentTableViewCell.swift
//  krombopulos-hw6
//
//  Created by Team Krombopulos on 9/20/16.
//  Copyright © 2016 Team Krombopulos. All rights reserved.
//
//  This class is an extension of UITableViewCell as a student table view cell.
//  Contains name and photo of students and allows for clicking.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    var bgColor: UIColor?
    var student: Student?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
