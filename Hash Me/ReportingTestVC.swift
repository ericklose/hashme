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
    
//    var trailReport1: TrailReportData!
//    var revenue: Int = 0
//    var attendeeCount: Int = 0
//    var paidAttendee: Int = 0
    let thisTrail: String = "-KI4iiL6h9hxdyWANBkh"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("confirm here, ", thisTrail)
        
        let trailReport1 = TrailReportData(trailKey: thisTrail)
        
                    self.topicOne.text = "Attendees"
                    self.resultOne.text = "\(trailReport1.attendeeCount)"
        
        
//        DataService.ds.REF_TRAILS.child(thisTrail).child("trailAttendees").observeEventType(.Value, withBlock: { snapshot in
//            
//            self.trails = []
//            //            let snap = snapshot
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap in snapshots {
//                    if let trailDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        print("trailDict: ", trailDict)
//                        if let trailAttendeeWasThere = trailDict["trailAttendeePresent"] as? Int {
//                            self.attendeeCount = self.attendeeCount + trailAttendeeWasThere
//                        }
//                        if let trailAttendeePaidAmt = trailDict["trailAttendeePaidAmt"] {
//                            self.revenue = self.revenue + Int(trailAttendeePaidAmt as! NSNumber)
//                            self.paidAttendee = self.paidAttendee + 1
//                        }
//                    }
//                }
//            }
//            self.topicOne.text = "Attendees"
//            self.resultOne.text = "\(self.attendeeCount)"
//            
//            self.topicTwo.text = "Revenue"
//            self.resultTwo.text = "$ \(self.revenue)"
//            
//            self.topicThree.text = "Paid Attendees"
//            self.resultThree.text = "\(self.paidAttendee)"
//            
//            self.topicFour.text = "Rev Per Attendee"
//            self.resultFour.text = "$ \(round((Double(self.revenue) / Double(self.attendeeCount))*100)/100)"
//            
//            self.topicFive.text = "Unpaid Attendees"
//            self.resultFive.text = "\(self.attendeeCount - self.paidAttendee)"
//        })
        
    }
}
