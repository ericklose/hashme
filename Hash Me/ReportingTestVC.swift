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
    var trailReport1: TrailReportData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("confirm here, ", thisTrail)
        
//        self.topicOne.text = "Attendees"
//        self.resultOne.text = "\(trailReport1.attendeeCount)"
//        self.topicTwo.text = "Paid Attendees"
//        self.resultTwo.text = "\(trailReport1.paidAttendee)"
//        self.topicThree.text = "People to Collect From"
//        self.resultThree.text = "\(trailReport1.attendeeCount - trailReport1.paidAttendee)"
//        self.topicFour.text = "Revenue"
//        self.resultFour.text = "\(trailReport1.revenue)"
        
        trailReport1 = TrailReportData(trailKey:  thisTrail) { () -> () in
            self.displayResults()
        }
        
        
    }
    
    func displayResults() {
        self.topicOne.text = "Attendees"
        self.resultOne.text = "\(trailReport1.attendeeCount)"
        self.topicTwo.text = "Paid Attendees"
        self.resultTwo.text = "\(trailReport1.paidAttendee)"
        self.topicThree.text = "People to Collect From"
        self.resultThree.text = "\(trailReport1.attendeeCount - trailReport1.paidAttendee)"
        self.topicFour.text = "Revenue"
        self.resultFour.text = "\(trailReport1.revenue)"
    }
}
