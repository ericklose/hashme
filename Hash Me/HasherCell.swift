//
//  HasherCell.swift
//  Hash Me
//
//  Created by Holly Klose on 4/4/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class HasherCell: UITableViewCell {
    
    @IBOutlet weak var kennelNameLbl: UILabel!
    @IBOutlet weak var deleteXButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(kennel: KennelData) {
        kennelNameLbl.text = kennel.kennelName
        
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
            if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                
                if let hashNames = hasherDict["hasherHashNames"] as? Dictionary<String, String> {
                    
                    let primaryHashName = hashNames.allKeysForValue("Primary")
                    let primary = primaryHashName[0]
                    print("primary: \(primary)")
                 //   self.hashNamesLbl.text = primary
                    
                    if hashNames.count > 1 {
                  //      let altHashNames = hasherDict["hasherHashName"] as? Dictionary<String, AnyObject>
                        
                        
                        
                        for var x = 0; x < hashNames.count; x += 1 {
                            let altHashNames = [String](hashNames.keys)
                            let altName = altHashNames[x]
                            print("altName: \(altName)")
                            
                         
                            if altName != primary {
                               let altNameKennelId = hashNames[altName]!
                                print("altNameKennelId: \(altNameKennelId)")
                            }
                            
                        }
                        
                    }
                    
                }
            }
            })
        
        
        
        if let kennelStatus = kennel.kennelDict["kennelId"] {
            if kennelStatus as! String == "Primary" {
                //attach primary hash name
                
                
                
                
            } else {
                //not sure
            }
        }
        
    }

}
