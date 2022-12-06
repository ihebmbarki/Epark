//
//  ParkViewController.swift
//  Epark
//
//  Created by iheb mbarki on 10/11/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ParkViewController: UIViewController, ObservableObject{
        
    var docRef : DocumentReference!


    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var registrationPlateTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sliderDuration: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var bookSpaceBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        SetUpElements()
//        createDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(changethedate), for: .valueChanged)

                
    }
    
    @IBAction func sliderDidchanged(_ sender: UISlider) {
        let numberOfSlots = 24*4 - 1
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "h:mm"
        let zeroDate = dateFormat.date(from: "\(dateFormat.string(from: datePicker.date))")
        
        let actualSlot = roundf(Float(numberOfSlots)*Float(sender.value))
        let slotInterval:TimeInterval = TimeInterval(actualSlot * 15 * 60)
        let slotDate: NSDate = NSDate(timeInterval: slotInterval, since: zeroDate!)
        sliderLabel.text = dateFormat.string(from: slotDate as Date)
    }

    
    
    @objc func changethedate(datePicker1: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateLabel.text = "\(dateFormatter.string(from: datePicker1.date))"
        
    }
    
    func SetUpElements() {
        errorLabel.alpha = 0
        Utilities.styleFilledButton(bookSpaceBtn)
        Utilities.styleTextField(firstNameTF)
        Utilities.styleTextField(lastNameTF)
        Utilities.styleTextField(registrationPlateTF)
    }
    
    func validateFields () -> String? {
        
        if firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            registrationPlateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        return nil
    }

    
    @IBAction func bookSpaceBtnTapped(_ sender: Any) {
        
        //Validate fields
        let error = validateFields()
        
        if error != nil {
            //error with the fields
            showError(error!)
        }
        else {
            //Create cleaned version of data
            guard let firstname = firstNameTF.text, !firstname.isEmpty else { return }
            guard let lastname = lastNameTF.text, !lastname.isEmpty else { return }
            guard let plates = registrationPlateTF.text, !plates.isEmpty else { return }
            guard let date = dateLabel.text, !date.isEmpty else { return }
            guard let timetoleaveParking = sliderLabel.text, !timetoleaveParking.isEmpty else {return}
           
            //Save cleaned data to firestore
            let db = Firestore.firestore()
            db.collection("reservation").addDocument(data: ["firstname": firstname, "lastname": lastname, "plates": plates, "date": date, "timetoleaveParking": timetoleaveParking]) { error in
                
                if error != nil {
                    self.showError("Error saving reservation")
                }
            }
            
    }
        self.view.layoutIfNeeded()

        let alert = UIAlertController(title: "Hello", message: "Space booked !", preferredStyle: .alert)
        
        //Define action
        let okayAction = UIAlertAction(title: "Okay", style: .default) {
            (action) in
            print(action)
        }
        
        //Add alert
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
  }
    
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    

}

