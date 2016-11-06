//
//  StudentTableViewController.swift
//  krombopulos-hw6
//
//  Created by Team Krombopulos on 9/20/16.
//  Copyright © 2016 Team Krombopulos. All rights reserved.
//
//  This class is an extension of UITableViewController as a student table view controller with searchability.
//  Contains cells of students with clickability.
//

import UIKit

class StudentTableViewController: UITableViewController, UISearchBarDelegate {
    
    var searchActive : Bool = false
    var students = [Student]()
    var teams = [Team]()
    var filtered = [Student]()
    var swipeIndex = -1
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedStudents = loadStudents() {
            for student in savedStudents{
                addStudent(student: student)
            }
        }
        else{
            loadTeam()
        }
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getAdam() -> Student{
        let image = UIImage(named: "adam")!
        let name: String = "Adam Tache"
        let from: String = "Pembroke Pines, Florida"
        let program: String = "Undergraduate"
        let years : Int = 3
        let degree: String = "B.S.E. Electrical & Computer Engineering, B.S. Computer Science, and Mathematics minor"
        let gender: Student.Gender = .Male
        let interests: [String] = ["software engineering", "virtual and augmented reality", "drones and robotics", "photography and filmmaking"]
        let languages: [String] = ["Java,", "Python", "C", "C++", "MATLAB", "Javascript", "HTML", "CSS"]
        let team: String = "Krombopulus"
        let student = Student(im: image, n: name, loc: from, py: years, d: degree, l: languages, i: interests, g: gender, p: program, team: team)
        return student
    }
    
    func getMatt() -> Student{
        let image = UIImage(named: "matt")!
        let name: String = "Matt Battles"
        let from: String = "New Jersey"
        let program: String = "Undergraduate"
        let years : Int = 4
        let degree: String = "B.S.E. Electrical & Computer Engineering, B.S. Computer Science"
        let gender: Student.Gender = .Male
        let interests: [String] = ["software engineering"]
        let languages: [String] = ["Java", "C#", "C", "MATLAB", "Python"]
        let team: String = "Krombopulus"
        let student = Student(im: image, n: name, loc: from, py: years, d: degree, l: languages, i: interests, g: gender, p: program, team: team)
        return student
    }
    
    func getSteven() -> Student{
        let image = UIImage(named: "steven")!
        let name: String = "Steven Katsohirakis"
        let from: String = "Utah"
        let program: String = "Undergraduate"
        let years : Int = 4
        let degree: String = "B.S.E. Electrical & Computer Engineering, B.S. Computer Science"
        let gender: Student.Gender = .Male
        let interests: [String] = ["software engineering", "application development"]
        let languages: [String] = ["Java", "C", "Swift", "JavaScript"]
        let team: String = "Krombopulus"
        let student = Student(im: image, n: name, loc: from, py: years, d: degree, l: languages, i: interests, g: gender, p: program, team: team)
        return student
    }
    
    func loadTeam() {
        let adam = getAdam()
        let matt = getMatt()
        let steven = getSteven()
        addStudent(student: adam)
        addStudent(student: matt)
        addStudent(student: steven)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return filtered.count
        }
        return teams.count+students.count
    }
    
    func isStudentCell(cellForRowAt indexPath: IndexPath) -> Bool{
        let row = (indexPath as NSIndexPath).row
        var count = 0
        for team in teams{
            if(row == count){
                return false
            }
            count = count + 1
            let numStudents = team.students.count
            count = count + numStudents
            if(row < count){
                return true
            }
        }
        return false
    }
    
    func getStudent(cellForRowAt indexPath: IndexPath) -> Student?{
        let row = (indexPath as NSIndexPath).row
        var count = 0
        for team in teams{
            count = count + 1
            for student in team.students{
                if(row == count){
                    return student
                }
                count = count + 1
            }
            
        }
        return nil
    }
    
    func getTeam(cellForRowAt indexPath: IndexPath) -> Team?{
        let row = (indexPath as NSIndexPath).row
        var count = 0
        for team in teams{
            if(row == count){
                return team
            }
            count = count + 1 + team.students.count
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isStudentCell = self.isStudentCell(cellForRowAt: indexPath)
        if(isStudentCell){
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as! StudentTableViewCell
            let student : Student
            if(searchActive){
                student = filtered[(indexPath as NSIndexPath).row - 1]
            }
            else{
                student = getStudent(cellForRowAt: indexPath)!
            }
            cell.student = student
            cell.nameLabel.text = student.name
            cell.photoImageView.image = student.image
            cell.contentView.backgroundColor = student.bgColor
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell", for: indexPath) as! TeamTableViewCell
        let team : Team = getTeam(cellForRowAt: indexPath)!
        cell.teamLabel.text = "Team \(team.name)"
        return cell
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    @IBAction func unwindToStudentList(_ sender: UIStoryboardSegue) {
        if (sender.source.isKind(of: CentralViewController.self)) {
            let source:CentralViewController = sender.source as! CentralViewController
            if (source.data != "") {
                let json = convertStringToDictionary(text: source.data)
                addStudent(student: Student.init(json: json!))
            }
        }
        if let sourceViewController = sender.source as? StudentViewController, let thisStudent = sourceViewController.student {
            if swipeIndex != -1{
                copyStudent(student: getStudent(cellForRowAt: IndexPath(row: swipeIndex, section: 0))!, copy: thisStudent)
                tableView.reloadRows(at: [IndexPath(row: swipeIndex, section: 0)], with: .none)
            }
            else if let selectedIndexPath = tableView.indexPathForSelectedRow{
                copyStudent(student: getStudent(cellForRowAt: selectedIndexPath)!, copy: thisStudent)
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                addStudent(student: thisStudent)
            }
            saveStudents()
        }
        self.swipeIndex = -1
    }
    
    func copyStudent(student: Student, copy: Student){
        student.name = copy.name
        student.location = copy.location
        student.program = copy.program
        student.yearInProgram = copy.yearInProgram
        student.degree = copy.degree
        student.languages = copy.languages
        student.interests = copy.interests
        student.image = copy.image
        student.team = copy.team
        student.gender = copy.gender
        student.pronoun = copy.pronoun
        student.genderVerb = copy.genderVerb
        student.isMale = copy.isMale
        student.bgColor = copy.bgColor
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isStudentCell(cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.swipeIndex = (indexPath as NSIndexPath).row
            self.performSegue(withIdentifier: "EditOnSlide", sender: indexPath)
        }
        edit.backgroundColor = UIColor.green
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.deleteStudent(student: self.getStudent(cellForRowAt: indexPath)!, editActionsForRowAt: indexPath)
        }
        delete.backgroundColor = UIColor.red
        return [edit, delete]
    }
    
    func addStudent(student: Student){
        var studentTeam : Team?
        for team in teams{
            if(team.name == student.team){
                studentTeam = team
                break
            }
        }
        if(studentTeam === nil){
            let cell = TeamTableViewCell()
            studentTeam = Team(n: student.team)
            cell.teamLabel = UILabel()
            cell.teamLabel.text = "Team \(student.team)"
            teams.append(studentTeam!)
            var count = 0
            for team in teams{
                count += team.students.count + 1
            }
        }
        studentTeam?.students.append(student)
        students.append(student)
        self.tableView.reloadData()
        saveStudents()
        
        
    }
    
    func deleteStudent(student: Student, editActionsForRowAt indexPath: IndexPath){
        var removalIndex = 0
        for stud in students{
            if stud.isEqual(student){
                break
            }
            removalIndex = removalIndex + 1
        }
        students.remove(at: removalIndex)
        var teamIndex = 0
        for team in teams{
            var hit = false
            var removalIndex = 0
            for stud in team.students{
                if stud.isEqual(student){
                    hit = true
                    break
                }
                removalIndex = removalIndex + 1
            }
            if(hit == true){
                team.students.remove(at: removalIndex)
                if(team.students.count == 0){
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    teams.remove(at: teamIndex)
                }
            }
            teamIndex = teamIndex + 1
        }
        self.tableView.reloadData()
        saveStudents()
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteStudent(student: (tableView.cellForRow(at: indexPath) as! StudentTableViewCell).student!, editActionsForRowAt: indexPath)
            saveStudents()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditOnSlide" {
            if let indexPath = sender as? IndexPath {
                let studentDetailViewController = segue.destination as! StudentViewController
                studentDetailViewController.student = getStudent(cellForRowAt: indexPath)
            }
        }
        if segue.identifier == "ShowDetail" {
            let studentDetailViewController = segue.destination as! PageViewController
            if let selectedStudentCell = sender as? StudentTableViewCell {
                let indexPath = tableView.indexPath(for: selectedStudentCell)!
                studentDetailViewController.student = getStudent(cellForRowAt: indexPath)
            }
        }
    }
    
    func saveStudents(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(students, toFile: Student.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save students.")
        }
    }
    
    func loadStudents() -> [Student]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Student.ArchiveURL.path) as? [Student]
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = students.filter({ (student) -> Bool in
            let tmp: NSString = student.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
}
