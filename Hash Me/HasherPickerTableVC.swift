//
//  HasherPickerTableVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/21/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class HasherPickerTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var hasherPickerTableView: UITableView!
    
    @IBOutlet weak var hasherPickerTableSearchBar: UISearchBar!
    var inSearchMode: Bool = false
    
    var hashers: [Hasher]!
    var filteredHashers: [Hasher]!
    var hasherChoice: Hasher!
    var kennelNamesDict: Dictionary<String, String> = [:]
    var hasherChoiceName: String!
    var hasherChoiceId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        hasherPickerTableView.delegate = self
        hasherPickerTableView.dataSource = self
        hasherPickerTableSearchBar.delegate = self
        hasherPickerTableSearchBar.returnKeyType = UIReturnKeyType.done
        hasherPickerTableView.tableFooterView = UIView()
        
        
        DataService.ds.REF_KENNELS.observe(.value, with: { snapshot in
            
            self.kennelNamesDict = [:]
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let kennelDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let kennelName = kennelDict["kennelName"] as! String
                        self.kennelNamesDict[key] = kennelName
                    }
                }
            }
            self.hasherPickerTableView.reloadData()
        })
        
        
        DataService.ds.REF_HASHERS.observe(.value, with: { snapshot in
            
            self.hashers = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let hasherDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let hasher = Hasher(hasherInitId: key, hasherInitDict: hasherDict)
                        self.hashers.append(hasher)
                    }
                }
            }
            self.hasherPickerTableView.reloadData()
        })
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hashers == nil {
            return 0
        } else if inSearchMode {
            return filteredHashers.count
        } else {
            return hashers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "hasherPickerCell") as? HasherPickerTableCell {
            let hasherResult: Hasher!
            if inSearchMode {
                hasherResult = filteredHashers[(indexPath as NSIndexPath).row]
            } else {
                hasherResult = hashers[(indexPath as NSIndexPath).row]
            }
            cell.configureCell(hasherResult, kennelNamesDict: kennelNamesDict)
            return cell
        } else {
            return HasherPickerTableCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "getHasherFromTable", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getHasherFromTable" {
            let selectedIndex = hasherPickerTableView.indexPathForSelectedRow
            if inSearchMode {
                hasherChoice = filteredHashers[(selectedIndex! as NSIndexPath).row]
            } else {
                hasherChoice = hashers[(selectedIndex! as NSIndexPath).row]
            }
            hasherChoiceId = hasherChoice.hasherId
            hasherChoiceName = hasherChoice.hasherPrimaryHashName
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.hasherPickerTableView.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredHashers = hashers.filter({$0.hasherPrimaryHashName.lowercased().range(of: lower) != nil || $0.hasherNerdName.lowercased().range(of: lower) != nil})
            self.hasherPickerTableView.reloadData()
        }
    }
}
