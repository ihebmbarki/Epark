//
//  QRScanVC.swift
//  Epark
//
//  Created by iheb mbarki on 10/11/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class QRScanVC: UIViewController {

    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var cinTf: UITextField!
    @IBOutlet weak var plateTf: UITextField!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var qrButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements () {
        
        //Hide the error label
        errorLabel.alpha = 0
        
        //Style the elements
        Utilities.styleTextField(nameTf)
        Utilities.styleTextField(cinTf)
        Utilities.styleTextField(plateTf)
        Utilities.styleFilledButton(qrButton)
    }
    
    func validateFields () -> String? {
        
         if nameTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cinTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            plateTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        return nil
    }
    

    @IBAction func qrtapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            //error with the fields
            showError(error!)
        }
        else {
            let dict = ["name": nameTf.text!, "cin": cinTf.text!, "plate": plateTf.text!]
            print("dict :: \(dict)")

            let db = Firestore.firestore()
            db.collection("QR code").addDocument(data: dict) { [self] error in
                
                if error != nil {
                    self.showError("Error saving QR code")
                }
                qrImageView.image = QRGenerator.generate(from: dict)

        }
            self.view.layoutIfNeeded()
            
            let alert = UIAlertController(title: "Hello", message: "QR saved!", preferredStyle: .alert)
            
            //Define action
            let okayAction = UIAlertAction(title: "Okay", style: .default) {
                (action) in
                print(action)
            }
            
            //Add alert
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: nil)
   }
    
}

class QRGenerator {
    static func generate(from dict: [String: String]) -> UIImage? {
        do {
            let jsonData = try JSONEncoder().encode(dict)
            if let filter = CIFilter(name: "CIQRCodeGenerator"){
                filter.setValue(jsonData, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                
                if let output = filter.outputImage?.transformed(by: transform) {
                    return UIImage(ciImage: output)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
  }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
