//
//  LoginViewController.swift
//  restaurantPOS_Assist
//
//  Created by Chris Janowski on 11/7/17.
//  Copyright © 2017 Chris Janowski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    //
    // Create FirebaseDatabase reference
    //
    
    var ref:DatabaseReference!
    var uid:String = ""

    //
    // Views and fields in UI
    //
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var signInRegisterLabel: UILabel!
    @IBOutlet weak var signInRegisterSeg: UISegmentedControl!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var signinRegisterButton: UIButton!
    
    var isSigningIn = true
    @IBAction func changeSignInRegister(_ sender: Any) {
        
        isSigningIn = !isSigningIn
        
        if isSigningIn {
            signInRegisterLabel.text = "Sign In"
            signinRegisterButton.setTitle("Sign In", for: .normal)
            confirmLabel.isHidden = true
            confirmPasswordTF.isHidden = true
        } else {
            signInRegisterLabel.text = "Register"
            signinRegisterButton.setTitle("Register", for: .normal)
            confirmLabel.isHidden = false
            confirmPasswordTF.isHidden = false
        }
        
    }
    
    //
    // Create ui alert with header and message
    //
    
    func createSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signinOrRegister(_ sender: Any) {

        //
        // Determine if signing in or registering
        //

        if isSigningIn {
            //
            // Sign in and fetch data in next view
            //
            
            guard let email = emailTF.text, let pass = passwordTF.text else {
                self.createSimpleAlert(title: "Error", message: "Username or password incorrect.")
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                
                //
                // Check user is not null
                //
                
                guard let userid = user?.uid else {
                    
                    self.createSimpleAlert(title: "Error", message: "Username or password incorrect.")
                    return
                }
                
                UserDefaults.standard.synchronize()
                
                self.uid = userid
                
                //
                // uid should be the second layer in database for multiple users
                //
                
                self.passwordTF.text = ""
                
                self.performSegue(withIdentifier: "loginseg", sender: self)
                
            })
            
            
        } else {
            //
            // Register and set up new data set, then segue
            //
            
            guard let email = emailTF.text, let pass = passwordTF.text, let confirmPass = confirmPasswordTF.text else {
                self.createSimpleAlert(title: "Error", message: "Username or password incorrect.")
                return
            }
            
            guard (pass == confirmPass) || pass.count > 6 else {
                self.createSimpleAlert(title: "Error", message: "Passwords must match and be longer than six characters.")
                return
            }
            
            
            Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                
                guard let loginid = user?.uid else {
                    self.createSimpleAlert(title: "Error", message: "Failed to create user. Try again.")
                    return
                    
                }
                
                self.uid = loginid
                
                let usersRef = self.ref.child("users").child(self.uid)
                let values = [
                    "email": email,
                    "password": pass,
                    "id": self.uid
                    ] as [String : Any]
                
                usersRef.updateChildValues(values)
                
                self.passwordTF.text = ""
                self.confirmPasswordTF.text = ""
                
                
                self.performSegue(withIdentifier: "loginseg", sender: self)
                
            })
        }
        
        
    }
    
    //
    // Prepare each piece of data to be edited in respective next view
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginseg") {
            let destVC = segue.destination as! MainMenuViewController
            destVC.uid = uid
        }
        
        
    } //end segue
    
    //
    // Set up design for VC
    //
    
    func initView() {
        mainView.layer.cornerRadius = 10;
        mainView.layer.masksToBounds = true;
        
        mainView.layer.borderColor = UIColor.black.cgColor
        mainView.layer.borderWidth = 0.5
        
        mainView.layer.contentsScale = UIScreen.main.scale
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 5.0
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.masksToBounds = false
        mainView.clipsToBounds = false
        
        confirmLabel.isHidden = true
        confirmPasswordTF.isHidden = true
        
        //
        // creating done button to close keyboards
        //
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        
        emailTF.inputAccessoryView = toolBar
        passwordTF.isSecureTextEntry = true
        passwordTF.inputAccessoryView = toolBar
        confirmPasswordTF.isSecureTextEntry = true
        confirmPasswordTF.inputAccessoryView = toolBar
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // init database reference
        //
        
        ref = Database.database().reference()

        //
        // set up view
        //
        
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
