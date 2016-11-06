//
//  DisplayViewController.swift
//  krombopulos-hw6
//
//  Created by Team Krombopulos on 9/20/16.
//  Copyright © 2016 Team Krombopulos. All rights reserved.
//
//  This class is an extension of UIViewController as a student display view controller to display student information.
//  Displays student description, photo, and allows for editing.
//

import UIKit

class DisplayViewController: UIViewController {
    
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    var student: Student!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(descriptionView != nil){
            descriptionView.text = student.description
            descriptionView?.numberOfLines = 10
            descriptionView.adjustsFontSizeToFitWidth = true
            descriptionView.minimumScaleFactor = 0.1
            photoView.image = student.image
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDetail" {
            let studentDetailViewController = segue.destination as! StudentViewController
            studentDetailViewController.student = student
        } else if (segue.identifier == "sendData") {
            let navController = segue.destination as! UINavigationController
            let pvc = navController.topViewController as! PeripheralViewController
            pvc.updateStudent(student: student)
        }
    }
    
}
