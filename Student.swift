//
//  Human.swift
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

extension String{
    /* Helper function for capitizalizing first character of String. */
    var first: String{
        return String(characters.prefix(1))
    }
    var uppercaseFirst: String{
        return first.uppercased() + String(characters.dropFirst())
    }
}

class Student: NSObject, NSCoding {
    
    var name: String
    var team: String
    var location: String
    var yearInProgram: Int
    var degree: String
    var languages: [String]
    var interests: [String]
    var pronoun: String
    var genderVerb: String
    var gender: Gender
    var program: String
    var image: UIImage!
    var bgColor: UIColor
    var isMale: Bool
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("students")
    
    /*
     Struct holding keys for various student properties.
    */
    struct PropertyKey{
        static let nameKey = "name"
        static let photoKey = "image"
        static let locationKey = "location"
        static let yearInProgramKey = "programYear"
        static let degreeKey = "degree"
        static let languagesKey = "languages"
        static let interestsKey = "interests"
        static let genderKey = "gender"
        static let programKey = "program"
        static let bgcolorKey = "bgColor"
        static let teamKey = "team"
    }
    
    /*
     Gender enum with values male, female, nonbinary
    */
    enum Gender : String{
        case Male, Female, Nonbinary
    }
    
    /*
     Helper method for encoding student based on property keys.
    */
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(image, forKey: PropertyKey.photoKey)
        aCoder.encode(location, forKey: PropertyKey.locationKey)
        aCoder.encode(yearInProgram, forKey: PropertyKey.yearInProgramKey)
        aCoder.encode(degree, forKey: PropertyKey.degreeKey)
        aCoder.encode(languages, forKey: PropertyKey.languagesKey)
        aCoder.encode(interests, forKey: PropertyKey.interestsKey)
        aCoder.encode(gender.rawValue, forKey: PropertyKey.genderKey)
        aCoder.encode(program, forKey: PropertyKey.programKey)
        aCoder.encode(bgColor, forKey: PropertyKey.bgcolorKey)
        aCoder.encode(team, forKey: PropertyKey.teamKey)
    }
    
    /*
     Helper method for decoding student based on property keys.
    */
    required convenience init?(coder aDecoder: NSCoder){
        let savedName = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let savedPhoto = aDecoder.decodeObject(forKey: PropertyKey.photoKey) as? UIImage
        let savedLocation = aDecoder.decodeObject(forKey: PropertyKey.locationKey) as! String
        let savedYearsInProgram = aDecoder.decodeInteger(forKey: PropertyKey.yearInProgramKey)
        let savedDegree = aDecoder.decodeObject(forKey: PropertyKey.degreeKey) as! String
        let savedLanguages = aDecoder.decodeObject(forKey: PropertyKey.languagesKey) as! [String]
        let savedInterests = aDecoder.decodeObject(forKey: PropertyKey.interestsKey) as! [String]
        let savedGender = Gender(rawValue: (aDecoder.decodeObject(forKey: PropertyKey.genderKey) as! String))
        let savedProgram = aDecoder.decodeObject(forKey: PropertyKey.programKey) as! String
        let savedColor = aDecoder.decodeObject(forKey: PropertyKey.bgcolorKey) as! UIColor
        let savedTeam = aDecoder.decodeObject(forKey: PropertyKey.teamKey) as! String
        self.init(im: savedPhoto, n: savedName, loc: savedLocation, py: savedYearsInProgram, d: savedDegree, l: savedLanguages, i: savedInterests, g: savedGender!, p: savedProgram, bg: savedColor, team: savedTeam)
    }
    
    /*
     Method for returning description of student based on their characteristics.
    */
    override var description: String {
        var toReturn : String = "\(name) is \(gender.rawValue.lowercased())"
        if(location != ""){
             toReturn = "\(toReturn) and \(genderVerb) from \(location)."
        }
        else{
            toReturn = "\(toReturn)."
        }
        if(program != ""){
            toReturn = "\(toReturn) \(pronoun) \(genderVerb) in year \(yearInProgram) of \(program) pursuing \(degree)."
        }
        else{
            toReturn = "\(toReturn) \(pronoun) \(genderVerb) is pursuing no degree."
        }
        if(languages.count > 0){
            toReturn = "\(toReturn) " + pronoun.uppercaseFirst + " programs in " + languages.joined(separator: ", ") + "."
        }
        else{
            toReturn = "\(toReturn) \(pronoun) programs in nothing."
        }
        if(interests.count > 0){
            toReturn = "\(toReturn) " + pronoun.uppercaseFirst + " enjoys " + interests.joined(separator: ", ")+"."
        }
        else{
            toReturn = "\(toReturn) " + pronoun.uppercaseFirst + " has no interests."
        }
        return toReturn
    }
    
    /*
     Constructor for creating new student. Sets random background color.
    */
    init(im: UIImage?, n: String, loc: String, py: Int, d: String, l: [String], i: [String], g: Gender, p: String, team: String){
        self.name = n
        self.location = loc
        self.program = p
        self.yearInProgram = py
        self.degree = d
        self.languages = l
        self.interests = i
        self.image = im
        self.team = team
        
        switch g{
        case .Male:
            gender = .Male
            pronoun = "He"
            genderVerb = "is"
            isMale = true
        case .Female:
            gender = .Female
            pronoun = "She"
            genderVerb = "is"
            isMale = false
        default:
            gender = .Nonbinary
            pronoun = "They"
            genderVerb = "are"
            isMale = false
        }
        var colorArr : [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.gray, UIColor.orange, UIColor.brown, UIColor.cyan, UIColor.red, UIColor.magenta]
        self.bgColor = colorArr[Int(arc4random_uniform(UInt32(colorArr.count)))].withAlphaComponent(0.5)
    }
    
    /*
     Constructor for creating student with already existing background color.
    */
    init(im: UIImage?, n: String, loc: String, py: Int, d: String, l: [String], i: [String], g: Gender, p: String, bg: UIColor, team: String){
        self.name = n
        self.location = loc
        self.program = p
        self.yearInProgram = py
        self.degree = d
        self.languages = l
        self.interests = i
        self.image = im
        self.team = team
        
        switch g{
        case .Male:
            gender = .Male
            pronoun = "He"
            genderVerb = "is"
            isMale = true
        case .Female:
            gender = .Female
            pronoun = "She"
            genderVerb = "is"
            isMale = false
        default:
            gender = .Nonbinary
            pronoun = "They"
            genderVerb = "are"
            isMale = false

        }
        self.bgColor = bg
    }
    
    init(json: Dictionary<String, Any>) {
        self.name = json["name"] as! String
        self.location = json["from"] as! String
        if ((json["sex"] as! String).isEqual("true")) {
            self.isMale = true
        } else {
            self.isMale = false
        }
        if(self.isMale) {
            gender = .Male
            pronoun = "He"
            genderVerb = "is"
        } else {
            gender = .Female
            pronoun = "She"
            genderVerb = "is"
        }
        self.degree = json["degree"] as! String
        self.interests = json["hobbies"] as! [String]
        self.languages = json["languages"] as! [String]
        self.yearInProgram = 0
        self.program = ""
        var colorArr : [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.gray, UIColor.orange, UIColor.brown, UIColor.cyan, UIColor.red, UIColor.magenta]
        self.bgColor = colorArr[Int(arc4random_uniform(UInt32(colorArr.count)))].withAlphaComponent(0.5)
        self.team = json["team"] as! String
    }
    
    init(JSONString: String){
        let json = JSON(JSONString)
        self.name = json["name"].stringValue
        self.location = json["from"].stringValue
        switch json["sex"].stringValue{
        case "true":
            gender = .Male
            pronoun = "He"
            genderVerb = "is"
            isMale = true
        case "false":
            gender = .Female
            pronoun = "She"
            genderVerb = "is"
            isMale = false
        default:
            gender = .Nonbinary
            pronoun = "They"
            genderVerb = "are"
            isMale = false
        }
        self.degree = json["degree"].stringValue
        self.interests = json["hobbies"].arrayValue.map({$0["name"].stringValue})
        self.languages = json["languages"].arrayValue.map({$0["name"].stringValue})
        self.yearInProgram = 0
        self.program = ""
        var colorArr : [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.gray, UIColor.orange, UIColor.brown, UIColor.cyan, UIColor.red, UIColor.magenta]
        self.bgColor = colorArr[Int(arc4random_uniform(UInt32(colorArr.count)))].withAlphaComponent(0.5)
        self.team = json["team"].stringValue
    }
    
}
