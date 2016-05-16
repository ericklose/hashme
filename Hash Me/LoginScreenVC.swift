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
        DataService.ds.REF_BASE.childByAppendingPath("UidToHasherId").observeEventType(.Value, withBlock: { snapshot in
            if let userList = snapshot.value as? Dictionary<String, String> {
                if userList[DataService.ds.REF_UID] != nil {
                    self.userAlreadyConnectedToHasher = true
                    self.SEGUE_LOGGED_IN = "fullLogIn"
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
                        DataService.ds.createFirebaseUser(authData.uid, hasher: hasher)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            print("negative numbers!!!")
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
                                    DataService.ds.createFirebaseUser(authData.uid, hasher: hasher)
                                })
                                self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                    } else {
                        self.showErrorAlert("Could Not Login", msg: "Please check your username or password")
                    }
                } else {
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier(self.SEGUE_LOGGED_IN, sender: nil)
                }
            })
            
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")
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
        
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
