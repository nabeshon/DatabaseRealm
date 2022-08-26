//
//  ViewController.swift
//  DatabaseRealm
//
//  Created by 渡邉昇 on 2022/08/27.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var tableView: UITableView!

    var addresses: [[String : String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        Firebase.Firestore.firestore().collection("addresses").addSnapshotListener{ (querySnapshot, error) in
            guard let snapshot = querySnapshot else{
                print(error!)
                return
            }
            snapshot.documentChanges.forEach{ diff in
                if (diff.type == .added){
                    let name = diff.document.data()["name"] as! String
                    let address = diff.document.data()["address"] as! String

                    self.addresses.append([
                        "name": name,
                        "address": address,
                    ])
                    self.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func send() {
        let addressData = [
            "name": nameTextField.text,
            "address": addressTextField.text,
        ]

        Firebase.Firestore.firestore().collection("addresses").addDocument(data: addressData
        ) { err in
            if let err = err {
                print("送信できませんでした: \(err)")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = addresses[indexPath.row]["name"]
        cell.detailTextLabel?.text = addresses[indexPath.row]["address"]
        return cell
    }
}
