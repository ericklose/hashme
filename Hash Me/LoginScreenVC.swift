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
        
        try! FIRAuth.auth()?.signOut()
//        FIRDatabase.database().reference().unau
//        DataService.ds.REF_BASE.unauth()
        
        checkUserIdStatus { () -> () in
            self.autoLogInIfRecognized()
        }
    }
    
    func checkUserIdStatus(completed: DownloadComplete) {
        DataService.ds.REF_BASE.child("UidToHasherId").observeEventType(.Value, withBlock: { snapshot in
            print("1 ", NSUserDefaults.standardUserDefaults())
            if let userList = snapshot.value as? Dictionary<String, String> {
                print("2")
                //FIGURE OUT NSUserDefaults HERE
                //OK, so, I'm writing in a value that triggers the auto-log in but am not sure how to see if it's already set?
                //NSUserDefaults.standardUserDefaults().setValue("7be00fdd-8aa6-43fe-bb6d-b53c255bab7a", forKey: KEY_UID)
                if DataService.ds.REF_UID != nil {
                    print("3")
                    if let thisUsersHasherId = userList[DataService.ds.REF_UID] {
                        print("4")
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
        print("10")
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            print("11")
            self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    //FACEBOOK LATER
    
    //    @IBAction func attemptFacebookLogin(sender: UIButton!) {
    //        let facebookLogin = FBSDKLoginManager()
    //
    //        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
    //
    //            if facebookError != nil {
    //                print("Facebook login failed. Error \(facebookError)")
    //            } else {
    //                print(FBSDKAccessToken.currentAccessToken().tokenString)
    //                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
    //                print("successfully logged in with facbeook: \(accessToken)")
    //
    ////                FIRFacebookAuthProvider
    ////                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
    //
    //                    if error != nil {
    //                        print("login failed (step 2) \(error)")
    //                    } else {
    //                        print("logged in! \(authData)")
    //
    //                        let hasher = ["provider": authData.provider!]
    //                        DataService.ds.createFirebaseUser(authData.uid, user: hasher)
    //
    //                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
    //                        self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
    //                    }
    ////                })
    //            }
    //        }
    //    }
    
    @IBAction func attemptEmailLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            FIRAuth.auth()!.signInWithEmail(email, password: pwd, completion: { (authData, error) in
                if error != nil {
//                    I can get this to fire when it's a new account
                    print("top error level")
                    print(error)
                    if error == STATUS_ACCOUNT_NONEXIST || error == 17011 {
//                        I don't seem able to get into this level ... the error codes are different anyway
                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
                            if error != nil {
                                print("one of the error levels")
                                self.showErrorAlert("Could Not Create Account", msg: "dude, I have no idea")
                            } else {
                                print("key uid ", KEY_UID)
                                print("dict thing uid ", user?.uid)
                                NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                            }
                        })
                    } else {
                        //                    LOOK AT DOCS FOR ERROR TRAPPING
                    }
                }
                print("no error")
//                This works fine if it's a recognized user
                NSUserDefaults.standardUserDefaults().setValue(authData?.uid, forKey: KEY_UID)
                self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
            })
        }
        
        ////        TRY TO GET ERROR FREE LOGIN WORKING FIRST
        //        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
        //
        ////            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
        //                if error != nil {
        //                    print(error)
        //                    if error == STATUS_ACCOUNT_NONEXIST {
        //                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
        //                            if error != nil {
        //                                self.showErrorAlert("Could Not Create Account", msg: "Problem creating account: try something else")
        //                            } else {
        //                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
        //                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { err, authData in
        //                                    let hasher = ["provider": authData.provider!]
        //                                    DataService.ds.createFirebaseUser(authData.uid, user: hasher)
        //                                })
        //                                self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
        //                            }
        //                        })
        //                    } else {
        //                        self.showErrorAlert("Could Not Login", msg: "Please check your username or password")
        //                    }
        //                } else if let tempPassword = authData.providerData["isTemporaryPassword"] {
        //                    if tempPassword as! NSObject == true {
        //                        print("temp password login")
        //                        //Force user to set a new password
        //                        self.changeFirebasePassword(email, pwd: pwd)                    } else {
        //                        print("normal email login")
        //                        //Main email login
        //                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
        //                        self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
        //                    }
        //                } else {
        //                    self.showErrorAlert("Something's Wrong", msg: "Honestly, I'm confused at this point too")
        //                }
        //            })
        //        } else {
        //            self.showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")
        //        }
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
