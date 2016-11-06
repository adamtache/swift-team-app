//
//  Team
//  krombopulos-hw6
//
//  Created by Team Krombopulos on 9/12/16.
//  Copyright © 2016 Team Krombopulos. All rights reserved.
//
//  This class represents a student object.
//  Contains various properties related to student. Allows for archiving.
//

import UIKit
import Foundation

class Team: NSObject, NSCoding {
    
    var name: String
    var students : [Student]
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("teams")
    
    /*
     Struct holding keys for various student properties.
     */
    struct PropertyKey{
        static let nameKey = "name"
    }
    
    /*
     Helper method for encoding student based on property keys.
     */
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        
    }
    
    /*
     Helper method for decoding student based on property keys.
     */
    required convenience init?(coder aDecoder: NSCoder){
        let savedName = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        
        self.init(n: savedName)
    }
    
    /*
     Method for returning description of student based on their characteristics.
     */
    override var description: String {
        return name
    }
    
    /*
     Constructor for creating new team.
     */
    init(n: String){
        self.name = n
        self.students = []
    }
    
}
