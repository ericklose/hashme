//
//  ReportingTestVC.swift
//  Hash Me
//
//  Created by Eric Klose on 5/14/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class ReportingTestVC: UIViewController {
    
    @IBOutlet weak var topicOne: UILabel!
    @IBOutlet weak var topicTwo: UILabel!
    @IBOutlet weak var topicThree: UILabel!
    @IBOutlet weak var topicFour: UILabel!
    @IBOutlet weak var topicFive: UILabel!
    @IBOutlet weak var resultOne: UILabel!
    @IBOutlet weak var resultTwo: UILabel!
    @IBOutlet weak var resultThree: UILabel!
    @IBOutlet weak var resultFour: UILabel!
    @IBOutlet weak var resultFive: UILabel!

    var trails = [TrailData]()
    var mishmash: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.ds.REF_TRAILS.childByAppendingPath("-KHWaGste0AeiaJfCXf1").observeEventType(.Value, withBlock: { snapshot in
            
            self.trails = []
            let snap = snapshot
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
//                for snap in snapshots {
                    if let trailDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let trail = TrailData(trailKey: key, dictionary: trailDict)
                        self.mishmash = self.mishmash + trail.trailTitle
                        print("MISHMASH ", self.mishmash)
                        self.trails.append(trail)
//                    }
//                }
            }
            
            self.topicOne.text = "Total Trails"
            self.resultOne.text = "\(self.trails.count)"
            
            self.resultTwo.text = "self.mishmash"
        })

     topicTwo.text = "Trail Title Mashup"
        
    }



}
