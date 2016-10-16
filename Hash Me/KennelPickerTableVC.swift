//
//  KennelPickerTableVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/21/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class KennelPickerTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var kennelPickerTableView: UITableView!
    
    @IBOutlet weak var kennelPickerTableSearchBar: UISearchBar!
    var inSearchMode: Bool = false
    
    var kennels: [KennelData]!
    var filteredKennels: [KennelData]!
    var kennelChoice: KennelData!
    var kennelChoiceName: String!
    var kennelChoiceId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        kennelPickerTableView.delegate = self
        kennelPickerTableView.dataSource = self
        kennelPickerTableSearchBar.delegate = self
        kennelPickerTableSearchBar.returnKeyType = UIReturnKeyType.done
        kennelPickerTableView.tableFooterView = UIView()
        
        
        DataService.ds.REF_KENNELS.observe(.value, with: { snapshot in
            
            self.kennels = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let kennelDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let kennelName = kennelDict["kennelName"] as! String
                        let kennel = KennelData(kennelInitId: key, kennelInitDict: kennelDict, kennelInitName: kennelName)
                        self.kennels.append(kennel)
                    }
                }
            }
            self.kennelPickerTableView.reloadData()
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if kennels == nil {
            return 0
        } else if inSearchMode {
            return filteredKennels.count
        } else {
            return kennels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "kennelPickerCell") as? KennelPickerTableCell {
            let kennelResult: KennelData!
            if inSearchMode {
                kennelResult = filteredKennels[(indexPath as NSIndexPath).row]
            } else {
                kennelResult = kennels[(indexPath as NSIndexPath).row]
            }
            cell.configureCell(kennelResult)
            return cell
        } else {
            return KennelPickerTableCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "getKennelFromTable", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getKennelFromTable" {
            let selectedIndex = kennelPickerTableView.indexPathForSelectedRow
            if inSearchMode {
                kennelChoice = filteredKennels[(selectedIndex! as NSIndexPath).row]
            } else {
                kennelChoice = kennels[(selectedIndex! as NSIndexPath).row]
            }
            kennelChoiceId = kennelChoice.kennelId
            kennelChoiceName = kennelChoice.kennelName
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.kennelPickerTableView.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredKennels = kennels.filter({$0.kennelName.lowercased().range(of: lower) != nil})
            self.kennelPickerTableView.reloadData()
        }
    }
}
