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
        
        //DataService.ds.REF_BASE.unauth()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        checkUserIdStatus { () -> () in
            self.autoLogInIfRecognized()
        }
    }
    
    func checkUserIdStatus(completed: DownloadComplete) {
        DataService.ds.REF_BASE.childByAppendingPath("UidToHasherId").observeEventType(.Value, withBlock: { snapshot in
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
    
    @IBAction func fbbtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                print(FBSDKAccessToken.currentAccessToken().tokenString)
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("successfully logged in with facbeook: \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        print("login failed (step 2) \(error)")
                    } else {
                        print("logged in! \(authData)")
                        
                        let hasher = ["provider": authData.provider!]
                        DataService.ds.createFirebaseUser(authData.uid, user: hasher)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                if error != nil {
                    print(error)
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            if error != nil {
                                self.showErrorAlert("Could Not Create Account", msg: "Problem creating account: try something else")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { err, authData in
                                    let hasher = ["provider": authData.provider!]
                                    DataService.ds.createFirebaseUser(authData.uid, user: hasher)
                                })
                                self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                    } else {
                        self.showErrorAlert("Could Not Login", msg: "Please check your username or password")
                    }
                } else if let tempPassword = authData.providerData["isTemporaryPassword"] {
                    if tempPassword as! NSObject == true {
                        print("temp password login")
                        //Force user to set a new password
                        var passwordTextField: UITextField?
                        var passwordVerifyTextField: UITextField?
                        let alertController = UIAlertController(title: "Set A New Password", message: "Update Your Password From that Autogenerated One", preferredStyle: .Alert)
                        let updatePassword = UIAlertAction(title: "Update Password", style: .Default, handler: { (action) -> Void in
                            if let newPass = passwordTextField!.text where newPass != "" {
                                if passwordTextField!.text != passwordVerifyTextField!.text {
                                    self.showErrorAlert("Passwords Do Not Match", msg: "Try Again")
                                } else {
                                    DataService.ds.REF_BASE.changePasswordForUser(email, fromOld: pwd,
                                        toNew: newPass, withCompletionBlock: { error in
                                            if error != nil {
                                                self.showErrorAlert("Something Went Wrong", msg: "I don't know. Figure it out. Or just try again.")
                                            } else {
                                                //Logged in from a password change
                                                self.passwordField.text = ""
                                                self.showErrorAlert("Password Successfully Changed", msg: "Now use it to log in")
//  I'd love this to log in directly but it didn't do that right away and I'm sick of this. I should probably delete the lines below but fear losing my place or intent
//                                                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
//                                                self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
                                            }
                                    })
                                }
                            } else {
                                self.showErrorAlert("You need *A* password", msg: "There aren't even any password rules or anything!")
                            }
                        })
                        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                            print("Cancel Button")
                        }
                        alertController.addAction(updatePassword)
                        alertController.addAction(cancel)
                        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                            passwordTextField = textField
                            passwordTextField?.placeholder = "New Password"
                            passwordTextField?.secureTextEntry = true
                        }
                        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                            passwordVerifyTextField = textField
                            passwordVerifyTextField?.placeholder = "Verify Password"
                            passwordVerifyTextField?.secureTextEntry = true
                        }
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        print("normal email login")
                        //Main email login
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
                    }
                } else {
                    self.showErrorAlert("Something's Wrong", msg: "Honestly, I'm confused at this point too")
                }
            })
        } else {
            self.showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if userAlreadyConnectedToHasher == true {
            SEGUE_LOGGED_IN = "fullLogIn"
        } else {
            SEGUE_LOGGED_IN = "loggedIn"
        }
    }
    
    @IBAction func pressedForgotPassword(sender: UIButton) {
        if emailField.text == "" {
            emailField.backgroundColor = UIColor.redColor()
            emailField.placeholder = "Enter Email Address to Reset Password"
            showErrorAlert("Enter Email Address", msg: "Enter your email address to reset your password")
        } else {
            DataService.ds.REF_BASE.resetPasswordForUser(emailField.text, withCompletionBlock: { error in
                if error != nil {
                    self.showErrorAlert("Something Went Wrong", msg: "Do it again, but better. Maybe it's the wrong email.")
                } else {
                    self.showErrorAlert("Password Reset Email Sent", msg: "Check your email")
                }
            })
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
