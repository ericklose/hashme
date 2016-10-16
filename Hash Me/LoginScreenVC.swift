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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkUserIdStatus { () -> () in
            self.autoLogInIfRecognized()
        }
    }
    
    func checkUserIdStatus(_ completed: @escaping DownloadComplete) {
        DataService.ds.REF_BASE.child("UidToHasherId").observe(.value, with: { snapshot in
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
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: self.SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func attemptFacebookLogin(_ sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (facebookResult: FBSDKLoginManagerLoginResult?, facebookError: Error?) -> Void in
            
            if facebookError != nil {
                self.showErrorAlert("Facebook Login Failed", msg: "\(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.current().tokenString
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken!)
                FIRAuth.auth()?.signIn(with: credential, completion: { (authData, error) in
                    
                    if error != nil {
                        self.showErrorAlert("Facebook Login Failed on Step 2", msg: "\(facebookError)")
                    } else {
                        let hasher = ["provider": credential.provider]
                        DataService.ds.createFirebaseUser(authData!.uid, user: hasher)
                        
                        UserDefaults.standard.setValue(authData!.uid, forKey: KEY_UID)
                        self.performSegue(withIdentifier: self.SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func attemptEmailLogin(_ sender: UIButton!) {
        if let email = emailField.text , email != "", let pwd = passwordField.text , pwd != "" {
            FIRAuth.auth()!.signIn(withEmail: email, password: pwd, completion: { (authData, error) in
                if error != nil {
                    if error!._code == 17011 {
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
                    UserDefaults.standard.setValue(authData?.uid, forKey: KEY_UID)
                    self.performSegue(withIdentifier: self.SEGUE_LOGGED_IN, sender: nil)
                }
            })
        } else {
            showErrorAlert("Enter Username & Password", msg: "You must enter an email and a password")
        }
    }
    
    func createEmailAccount(_ email: String, pwd: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, err) in
            if err != nil {
                self.showErrorAlert("Account Creation Problem", msg: err!.localizedDescription)
            } else {
                UserDefaults.standard.setValue(user?.uid, forKey: KEY_UID)
                self.performSegue(withIdentifier: self.SEGUE_LOGGED_IN, sender: nil)
            }
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if userAlreadyConnectedToHasher == true {
            SEGUE_LOGGED_IN = "fullLogIn"
        } else {
            SEGUE_LOGGED_IN = "loggedIn"
        }
    }
    
    // LATER, BUT DON'T BREAK NOW
    @IBAction func pressedForgotPassword(_ sender: UIButton) {
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
