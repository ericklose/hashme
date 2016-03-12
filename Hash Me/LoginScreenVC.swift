//
//  LoginScreenVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class LoginScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var facebookLogin: UIButton!

    var ref = new Firebase("https://hashme.firebaseio.com");
    ref.authWithOAuthPopup("facebook", function(error, authData) {
    if (error) {
    console.log("Login Failed!", error);
    } else {
    console.log("Authenticated successfully with payload:", authData);
    }
    });
    

}
