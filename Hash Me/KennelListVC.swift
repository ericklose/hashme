//
//  KennelListVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/16/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
//import Firebase

class KennelListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var kennelListTable: UITableView!
    @IBOutlet weak var newKennelName: UITextField!
    @IBOutlet weak var newKennelCountry: UITextField!
    @IBOutlet weak var newKennelState: UITextField!
    
    var kennelList: KennelData!
    var kennels = [KennelData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround() 
        kennelListTable.delegate = self
        kennelListTable.dataSource = self
        kennelListTable.estimatedRowHeight = 100
        
        kennelList = KennelData(isFake: "fake")
        
        kennelList.getKennelInfo() { () -> () in
            self.kennels = self.kennelList.kennels
            print("reload happens?")
            self.kennelListTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("1xxx")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(" numRows :", kennels.count)
        kennelListTable.backgroundColor = color.red
        return kennels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let kennel: KennelData!
        kennel = kennels[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "manageKennel", sender: kennel)
                
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kennelListTable.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("are were here")
        let kennel = kennels[(indexPath as NSIndexPath).row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "kennelCell") as? KennelCell {
            print("line test")
            cell.configureCell(kennel)
            return cell
        } else {
            print("fail, I guess")
            return KennelCell()
        }
        
    }


    @IBAction func addNewKennel(_ sender: UIButton) {
        postKennelToFirebase()
    }

    func postKennelToFirebase() {
        
        let kennel: Dictionary<String, AnyObject> = [
            "kennelName": newKennelName.text! as AnyObject,
            "kennelCountry": newKennelCountry.text! as AnyObject,
            "kennelState": newKennelState.text! as AnyObject,
            "name": newKennelName.text! as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_KENNELS.childByAutoId()
        firebasePost.setValue(kennel)
        
        newKennelName.text = ""
        newKennelCountry.text = ""
        newKennelState.text = ""
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "manageKennel" {
            if let manageKennelVC = segue.destination as? ManageKennelVC {
                if let kennelInCell = sender as? KennelData {
                    manageKennelVC.kennels = kennelInCell
                }
            }
        }
    }

}
