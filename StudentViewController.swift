//
//  StudentViewController.swift
//  krombopulos-hw6
//
//  Created by Team Krombopulos on 9/10/16.
//  Copyright © 2016 Team Krombopulos. All rights reserved.
//
//  This class is an extension of UIViewController as a student view controller.
//  Contains visual elements for viewing and adjusting student properties.
//

import UIKit

class StudentViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /*
     The following are labels, switches, and sliders used for changing and displaying current student information.
    */
    var profileView: UIView!
    
    //let bluetoothButton = UIButton(type: .system)
    var bluetoothProgressSlider: UISlider! = UISlider()
    var bluetoothSliderLabel: UITextField! = UITextField()
    
    let cameraButton = UIButton(type: .system)
    let galleryButton = UIButton(type: .system)
    
    var nameLabelView: UILabel! = UILabel()
    var nameTextView: UITextField! = UITextField()
    
    var locationLabelView: UILabel! = UILabel()
    var locationTextView: UITextField! = UITextField()
    
    var genderLabelView: UILabel! = UILabel()
    var genderSwitch: UISwitch = UISwitch()
    var genderSwitchLabel: UILabel! = UILabel()
    
    var programLabelView: UILabel! = UILabel()
    var programTextView: UITextField! = UITextField()
    
    var yearsProgramLabelView: UILabel! = UILabel()
    var yearsProgramSliderView: UISlider! = UISlider()
    var yearSliderLabel: UITextField! = UITextField()
    
    var degreeLabelView: UILabel! = UILabel()
    var degreeTextView: UITextField! = UITextField()
    
    var languagesLabelView: UILabel! = UILabel()
    var languagesTextView: UITextField! = UITextField()
    
    var interestsLabelView: UILabel! = UILabel()
    var interestsTextView: UITextField! = UITextField()
    
    var teamTextView: UITextField! = UITextField()
    var teamLabelView: UILabel! = UILabel()
    
    var descriptionLabel: UILabel! = UILabel()
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let isPresentingInAddStudentMode = presentingViewController is UINavigationController
        
        if isPresentingInAddStudentMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    /*
     Holds current student, if there is a current student.
    */
    var student : Student?
    
    let screenSize: CGRect = UIScreen.main.bounds
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    var labelWidth : CGFloat = 125.0
    var labelHeight : CGFloat = 30.0
    
    /*
     When view loads, sets screen dimensions and fills table with relevant student information.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        profileView = self.view
        pictureButtonsSetup()
        if(student == nil){
            setupEmptyFields()
        }
        else{
            setupCurrStudent()
        }
        //setupBluetooth()
        setupProfileView()
        nameTextView!.delegate = self
        checkValidStudentName()
    }
    
    /*
     Sets fields to default values.
    */
    func setupEmptyFields(){
        setupName("Johny Appleseed")
        setupLocation("Weston, Florida")
        setupProgram("Masters")
        setupDegree("Electrical Engineering")
        setupGender()
        setupLanguages("Java,C,C++")
        setupInterests("Urban exploration,skiing")
        setupTeam("Jolly")
    }
    
    /*
     Sets fields to current student's values.
    */
    func setupCurrStudent(){
        setupName(student!.name)
        nameTextView.text = student!.name
        setupLocation(student!.location)
        locationTextView.text = student!.location
        setupProgram(student!.program)
        programTextView.text = student!.program
        setupDegree(student!.degree)
        degreeTextView.text = student!.degree
        setupGender()
        setupYearsInProgram()
        yearsProgramSliderView.value = Float(student!.yearInProgram)
        yearSliderLabel.text = String(student!.yearInProgram)
        genderSwitch.isOn = student!.gender == .Male
        genderSwitchLabel.text = student!.gender == .Male ? "Male" : "Female"
        setupLanguages(student!.languages.joined(separator: ","))
        languagesTextView.text = student!.languages.joined(separator: ",")
        setupInterests(student!.interests.joined(separator: ","))
        interestsTextView.text = student!.interests.joined(separator: ",")
        teamTextView.text = student!.team
        if(student!.image != nil){
            photoImageView.image = student!.image
        }
        else{
            photoImageView.image = UIImage(named: "defaultPhoto")!
        }
    }
    
    /*
     Sets labels and text views for profile page's information.
    */
    func setupProfileView(){
        profileView.addSubview(nameLabelView)
        profileView.addSubview(nameTextView)
        
        profileView.addSubview(locationLabelView)
        profileView.addSubview(locationTextView)
        
        profileView.addSubview(yearSliderLabel)
        profileView.addSubview(yearsProgramLabelView)
        profileView.addSubview(yearsProgramSliderView)
        
        profileView.addSubview(programLabelView)
        profileView.addSubview(programTextView)
        
        profileView.addSubview(genderLabelView)
        profileView.addSubview(genderSwitch)
        profileView.addSubview(genderSwitchLabel)
        
        profileView.addSubview(languagesLabelView)
        profileView.addSubview(languagesTextView)
        
        profileView.addSubview(interestsLabelView)
        profileView.addSubview(interestsTextView)
        
        profileView.addSubview(degreeLabelView)
        profileView.addSubview(degreeTextView)
        
        profileView.addSubview(descriptionLabel)
        
        profileView.addSubview(cameraButton)
        profileView.addSubview(galleryButton)
        
        profileView.addSubview(teamTextView)
        profileView.addSubview(teamLabelView)
    }
    
    /*
     Helper method for creating label.
     Accepts x,y location for where label appears on screen.
     Accepts labelWidth, labelHeight to customize size on screen.
    */
    func createLabelView(_ text: String, dx: CGFloat, dy: CGFloat, labelWidth: CGFloat, labelHeight: CGFloat) -> UILabel{
        let labelView = UILabel(frame: CGRect(x: dx, y: dy, width: labelWidth, height: labelHeight))
        labelView.isHidden = false
        labelView.backgroundColor = UIColor.white
        labelView.layer.borderColor = UIColor.black.cgColor
        labelView.text = text
        labelView.adjustsFontSizeToFitWidth = true
        return labelView
    }
    
    /*
     Helper method for creating text.
     Accepts x,y location for where text appears on screen.
     Accepts labelWidth, labelHeight to customize size on screen.
    */
    func createTextView(_ text: String, dx: CGFloat, dy: CGFloat, labelWidth: CGFloat, labelHeight: CGFloat) -> UITextField{
        let textView = UITextField(frame: CGRect(x: dx, y: dy, width: labelWidth*1.5, height: labelHeight))
        textView.isHidden = false
        textView.backgroundColor = UIColor.white
        textView.layer.borderColor = UIColor.black.cgColor
        textView.placeholder = text
        textView.tintColor = UIColor.black
        return textView
    }
    
    /*
     Helper method for creating slider.
     Accepts x,y location for where slider appears on screen.
     Accepts sliderWidth, sliderHeight to customize size on screen.
    */
    func createSliderView(_ min: Float, max: Float, dx: CGFloat, dy: CGFloat, sliderWidth: CGFloat, sliderHeight: CGFloat) -> UISlider{
        let slider : UISlider = UISlider()
        slider.minimumTrackTintColor = UIColor.black
        slider.minimumValue = min
        slider.maximumValue = max
        slider.isContinuous = true
        slider.tintColor = UIColor.black
        slider.frame = CGRect(x: dx, y: dy, width: sliderWidth, height: sliderHeight)
        return slider
    }
    
    /*
     Helper method for setting up name label and text.
     Accepts text, which is the name displayed.
    */
    func setupName(_ text: String){
        let dx : CGFloat = 20.0
        let dy : CGFloat = 105.0
        
        nameLabelView = createLabelView("Name", dx: dx, dy: dy, labelWidth: labelWidth, labelHeight: labelHeight)
        nameTextView = createTextView(text, dx: dx + 10 + labelWidth, dy: dy, labelWidth: 100, labelHeight: 30)
    }
    
    /*
     Helper method for setting up location label and text.
     Accepts text, which is the location displayed.
    */
    func setupLocation(_ text: String){
        let dx : CGFloat = 20.0
        let dy : CGFloat = 145.0
        
        locationLabelView = createLabelView("Location", dx: dx, dy: dy, labelWidth: labelWidth, labelHeight: labelHeight)
        locationTextView = createTextView(text, dx: dx + 10 + labelWidth, dy: dy, labelWidth: 100, labelHeight: 30)
    }
    
    /*
     Helper method for setting up program label and text.
     Accepts text, which is the program displayed.
    */
    func setupProgram(_ text: String){
        let dx : CGFloat = 20.0
        let dy : CGFloat = 185.0
        
        programLabelView = createLabelView("Program", dx: dx, dy: dy, labelWidth: labelWidth, labelHeight: labelHeight)
        programTextView = createTextView(text, dx: dx + 10 + labelWidth, dy: dy, labelWidth: 100, labelHeight: 30)
        
        setupYearsInProgram()
    }
    
    /*
     Helper method for setting up years in program label and slider.
    */
    func setupYearsInProgram(){
        let dx : CGFloat = 20.0
        let dy : CGFloat = 225.0
        
        yearsProgramLabelView = createLabelView("Years in Program", dx: dx, dy: dy, labelWidth: labelWidth, labelHeight: labelHeight)
        yearsProgramSliderView = createSliderView(1, max: 10, dx: dx + 10 + labelWidth, dy: dy, sliderWidth: 100, sliderHeight: 30)
        yearSliderLabel = createTextView("0", dx: dx + 10 + labelWidth + 100, dy: dy, labelWidth: 100, labelHeight: 30)
        yearSliderLabel.textColor = UIColor.black
        
        yearsProgramSliderView.addTarget (self, action: #selector(numberValueChanged), for: UIControlEvents.valueChanged)
    }
    
    /*
     Updates years in program slider with new value.
    */
    func numberValueChanged(_ sender: UISlider) {
        yearsProgramSliderView.setValue(Float(Int(yearsProgramSliderView.value)), animated: true)
        updateYearLabel(yearsProgramSliderView.value)
    }
    
    /*
     Updates year label with new year.
    */
    func updateYearLabel(_ nV: Float?) {
        if let v = nV {
            yearSliderLabel.text = "\(v)"
        }
    }
    
    /*
     Helper method for setting up gender switch and label.
    */
    func setupGender(){
        let dx : CGFloat = 20.0
        let dy : CGFloat = 265.0
        
        genderLabelView = createLabelView("Gender", dx: dx, dy: dy, labelWidth: labelWidth, labelHeight: labelHeight)
        genderSwitch = UISwitch(frame:CGRect(x: dx + labelWidth + 15, y: dy, width: 100, height: 30));
        genderSwitch.isOn = true
        genderSwitch.setOn(true, animated: false);
        genderSwitchLabel = createLabelView("Male", dx: dx + labelWidth + 75, dy: dy, labelWidth: 100, labelHeight: 30)
        genderSwitchLabel.textColor = UIColor.black
        genderSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
    }
    
    /*
     Helper method for switching gender text button
    */
    func switchValueDidChange(_ sender: UISwitch) {
        var text : String
        switch(genderSwitch.isOn){
        case true:
            text = "Male"
        default:
            text = "Female"
        }
        genderSwitchLabel.text = text
    }
    
    /*
     Helper method for setting up interests label and text.
    */
    func setupInterests(_ text: String){
        let dx : CGFloat = 20.0
        let dy : CGFloat = 305.0
        
        interestsLabelView = createLabelView("Interests", dx: dx, dy: dy, labelWidth: labelWidth, labelHeight: labelHeight)
        interestsTextView = createTextView(text, dx: dx + 10 + labelWidth, dy: dy, labelWidth: 100, labelHeight: 30)
    }
    
    /*
     Helper method for setting up languages label and text.
     */
    func setupLanguages(_ text: String){
        let dx : CGFloat = 20.0
        let dy : CGFloat = 345.0
        
        languagesLabelView = createLabelView("Languages", dx: dx, dy: dy, labelWidth: labelWidth, labelHeight: labelHeight)
        languagesTextView = createTextView(text, dx: dx + 10 + labelWidth, dy: dy, labelWidth: 100, labelHeight: 30)
    }
    
    /*
     Helper method for setting up degree label and text.
    */
    func setupDegree(_ text: String){
        let dx : CGFloat = 20.0
        let dy : CGFloat = 385.0
        
        degreeLabelView = createLabelView("Degree", dx: dx, dy: dy, labelWidth: labelWidth, labelHeight: labelHeight)
        degreeTextView = createTextView(text, dx: dx + 10 + labelWidth, dy: dy, labelWidth: 100, labelHeight: 30)
    }
    
    /*
     Helper method for setting up team label and text.
     Accepts text, which is the team displayed.
     */
    func setupTeam(_ text: String){
        let dx : CGFloat = 20.0
        let dy : CGFloat = 425.0
        
        teamLabelView = createLabelView("Team", dx: dx, dy: dy, labelWidth: labelWidth, labelHeight: labelHeight)
        teamTextView = createTextView(text, dx: dx + 10 + labelWidth, dy: dy, labelWidth: 100, labelHeight: 30)
    }
    
    /*
     Helper method for getting object corresponding to current student.
    */
    func getCurrentStudent() -> Student{
        let name : String = nameTextView.text!
        let from : String = locationTextView.text!
        let gender : Student.Gender
        switch(genderSwitch.isOn){
        case true:
            gender = .Male
        default:
            gender = .Female
        }
        
        let program : String = programTextView.text!
        let languages : [String] = languagesTextView.text!.characters.split{$0 == ","}.map(String.init)
        let years : Int = Int(yearsProgramSliderView.value)
        let interests : [String] = interestsTextView.text!.characters.split{$0 == ","}.map(String.init)
        let degree : String = degreeTextView.text!
        let image = photoImageView.image
        let team = teamTextView.text!
        let stud = Student(im: image, n: name, loc: from, py: years, d: degree, l: languages, i: interests, g: gender, p: program, team: team)
        return stud
    }
    
    /*
     Helper method for displaying current student's profile description.
    */
    func displayProfile(_ sender: UIButton!){
        let person : Student = getCurrentStudent()
        let description : String = person.description
        let dx : CGFloat = 10.0
        let dy : CGFloat = 385.0
        descriptionLabel = createLabelView(description, dx: dx, dy: dy, labelWidth: screenWidth - 20, labelHeight: 100)
        descriptionLabel?.numberOfLines = 3
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.1
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.isHidden = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    /*
     Segues from save button to student table view and updates cells accordingly.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch sender as! NSObject!{
        case self.saveButton:
            student = getCurrentStudent()
        default:
            _ = 0
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidStudentName()
        navigationItem.title = textField.text
    }
    
    /*
     Helper method for checking if student name is valid.
    */
    func checkValidStudentName(){
        let name = nameTextView.text ?? ""
        saveButton.isEnabled = !name.isEmpty
    }
    
    /*
     Sets up buttons to allow user to select photo from camera or gallery.
    */
    func pictureButtonsSetup() {
        let buttonWidth: CGFloat        = 80
        let buttonHeight: CGFloat       = 40
        let dx : CGFloat                = 10.0
        let dy : CGFloat                = 515.0
        
        cameraButton.frame = CGRect(x: dx, y: dy, width: buttonWidth, height: buttonHeight)
        cameraButton.setTitle("Camera", for: UIControlState.normal)
        cameraButton.backgroundColor = UIColor.blue
        cameraButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cameraButton.addTarget(self, action: #selector(StudentViewController.cameraSelected), for: UIControlEvents.touchUpInside)
        
        galleryButton.frame = CGRect(x: screenWidth - dx - buttonWidth, y: dy, width: buttonWidth, height: buttonHeight)
        galleryButton.setTitle("Gallery", for: UIControlState.normal)
        galleryButton.backgroundColor = UIColor.blue
        galleryButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        galleryButton.addTarget(self, action: #selector(StudentViewController.gallerySelected), for: UIControlEvents.touchUpInside)
        
    }
    
    /*
     Helper method that sets up bluetooth progress slider.
    */
    func setupBluetoothProgress(){
        let sliderWidth: CGFloat        = 100
        let sliderHeight: CGFloat       = 35
        let dx : CGFloat                = 175.0
        let dy : CGFloat                = 70.0
        
        bluetoothProgressSlider = createSliderView(0, max: 100, dx: dx, dy: dy, sliderWidth: sliderWidth, sliderHeight: sliderHeight)
        bluetoothSliderLabel = createTextView("0", dx: dx + sliderWidth, dy: dy+5, labelWidth: 100, labelHeight: 30)
        bluetoothSliderLabel.textColor = UIColor.black
        
        bluetoothProgressSlider.addTarget (self, action: #selector(progressValueChanged), for: UIControlEvents.valueChanged)
        bluetoothProgressSlider.isUserInteractionEnabled = false
    }
    
    /*
     Updates bluetooth progress slider.
     */
    func progressValueChanged(_ sender: UISlider) {
        bluetoothProgressSlider.setValue(Float(Int(bluetoothProgressSlider.value)), animated: true)
        updateProgressLabel(bluetoothProgressSlider.value)
    }
    
    /*
     Updates year label with new year.
     */
    func updateProgressLabel(_ nV: Float?) {
        if let v = nV {
            bluetoothSliderLabel.text = "\(v)"
        }
    }
    
    func cameraSelected() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func gallerySelected() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}
