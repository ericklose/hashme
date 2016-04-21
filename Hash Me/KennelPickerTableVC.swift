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
        kennelPickerTableView.delegate = self
        kennelPickerTableView.dataSource = self
        kennelPickerTableSearchBar.delegate = self
        kennelPickerTableSearchBar.returnKeyType = UIReturnKeyType.Done
        
        
        DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
            
            self.kennels = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if kennels == nil {
            return 0
        } else if inSearchMode {
            return filteredKennels.count
        } else {
            return kennels.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("kennelPickerCell") as? KennelPickerTableCell {
            let kennelResult: KennelData!
            if inSearchMode {
                kennelResult = filteredKennels[indexPath.row]
            } else {
                kennelResult = kennels[indexPath.row]
            }
            cell.configureCell(kennelResult)
            return cell
        } else {
            return KennelPickerTableCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("getKennelFromTable", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "getKennelFromTable" {
            let selectedIndex = kennelPickerTableView.indexPathForSelectedRow
            if inSearchMode {
                kennelChoice = filteredKennels[selectedIndex!.row]
            } else {
                kennelChoice = kennels[selectedIndex!.row]
            }
            kennelChoiceId = kennelChoice.kennelId
            kennelChoiceName = kennelChoice.kennelName
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.kennelPickerTableView.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredKennels = kennels.filter({$0.kennelName.lowercaseString.rangeOfString(lower) != nil})
            self.kennelPickerTableView.reloadData()
        }
    }
}
