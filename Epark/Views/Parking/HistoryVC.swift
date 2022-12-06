//
//  HistoryVC.swift
//  Epark
//
//  Created by iheb mbarki on 4/12/2022.
//

import UIKit
import Firebase

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = reservationsArray[indexPath.row]
        
        return cell
    }
    
    
    @IBOutlet var tableView: UITableView!
    
    var colRef: CollectionReference!
    var reservationsArray: Array<String>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        colRef = Firestore.firestore().collection("reservation")
        
        reservationsArray = []
        
        colRef.getDocuments() { (docsSnapshot, err) in
            if let err = err {
                print("error getting document \(err)")
            } else {
                for document in docsSnapshot!.documents {
                    self.reservationsArray.append(document["firstname"] as! String)
                    self.reservationsArray.append(document["lastname"] as! String)
                    self.reservationsArray.append(document["date"] as! String)
                    self.reservationsArray.append(document["timetoleaveParking"] as! String)


                }
            }
            
                DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    

}
