//
//  LoginScreenVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginScreenVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var userAlreadyConnectedToHasher = false
    var SEGUE_LOGGED_IN = "loggedIn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkUserIdStatus { () -> () in
            self.autoLogInIfRecognized()
        }
    }
    
    func checkUserIdStatus(completed: DownloadComplete) {
        DataService.ds.REF_BASE.child("UidToHasherId").observeEventType(.Value, withBlock: { snapshot in
            if let userList = snapshot.value as? Dictionary<String, String> {
                if DataService.ds.REF_UID != nil {
                    if let thisUsersHasherId = userList[DataService.ds.REF_UID] {
                        DataService.ds.storeRefHasherUserId(thisUsersHasherId)
                        self.userAlreadyConnectedToHasher = true
                        self.SEGUE_LOGGED_IN = "fullLogIn"
                    }
                }
            }
            completed()
        })
    }
    
    func autoLogInIfRecognized() {
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func attemptFacebookLogin(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            
            if facebookError != nil {
                self.showErrorAlert("Facebook Login Failed", msg: "\(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (authData, error) in
                    
                    if error != nil {
                        self.showErrorAlert("Facebook Login Failed on Step 2", msg: "\(facebookError)")
                    } else {
                        let hasher = ["provider": credential.provider]
                        DataService.ds.createFirebaseUser(authData!.uid, user: hasher)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData!.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func attemptEmailLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            FIRAuth.auth()!.signInWithEmail(email, password: pwd, completion: { (authData, error) in
                if error != nil {
                    if error!.code == 17011 {
                        self.createEmailAccount(email, pwd: pwd)
                        //                    } else if let tempPassword = authData!.providerData.["isTemporaryPassword"] {
                        //                        //TEMP PASSWORD
                        //                        if tempPassword as! NSObject == true {
                        //                            print("temp password login")
                        //                            //Force user to set a new password
                        //                            self.changeFirebasePassword(email, pwd: pwd)
                        //                        }
                    } else {
                        self.showErrorAlert("Sign In Problem", msg: error!.localizedDescription)
                    }
                } else {
                    NSUserDefaults.standardUserDefaults().setValue(authData?.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
                }
            })
        } else {
            showErrorAlert("Enter Username & Password", msg: "You must enter an email and a password")
        }
    }
    
    func createEmailAccount(email: String, pwd: String) {
        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, err) in
            if err != nil {
                self.showErrorAlert("Account Creation Problem", msg: err!.localizedDescription)
            } else {
                NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
            }
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if userAlreadyConnectedToHasher == true {
            SEGUE_LOGGED_IN = "fullLogIn"
        } else {
            SEGUE_LOGGED_IN = "loggedIn"
        }
    }
    
    // LATER, BUT DON'T BREAK NOW
    @IBAction func pressedForgotPassword(sender: UIButton) {
        //        if emailField.text == "" {
        //            emailField.backgroundColor = UIColor.redColor()
        //            emailField.placeholder = "Enter Email Address to Reset Password"
        //            showErrorAlert("Enter Email Address", msg: "Enter your email address to reset your password")
        //        } else {
        //            DataService.ds.REF_BASE.resetPasswordForUser(emailField.text, withCompletionBlock: { error in
        //                if error != nil {
        //                    self.showErrorAlert("Something Went Wrong", msg: "Do it again, but better. Maybe it's the wrong email.")
        //                } else {
        //                    self.showErrorAlert("Password Reset Email Sent", msg: "Check your email")
        //                }
        //            })
        //        }
    }
}
