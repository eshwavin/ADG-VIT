//
//  TwoCreditCourseViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 04/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import MessageUI
import LocalAuthentication

class TwoCreditCourseViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let databaseReference = FIRDatabase.database().reference().child("twoCredit").child("users")
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check for login
        if UserDefaults.standard.bool(forKey: "LoggedIn") == true {
            
            self.performSegue(withIdentifier: "goToMainPage", sender: self)
            
        }

        // reachability
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reachabilityChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        self.reachabilityChanged()
        
        // reveal view controller
        
        if revealViewController() != nil {
            self.menuButton.target = revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = SWRevealWidth
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // navigation controller
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.title = "Login"
        
        // adding placeholder attributes to the text fields
        
        let attributeDictionary = [NSFontAttributeName: UIFont(name: "Avenir Medium", size: 19)!, NSForegroundColorAttributeName: color(red: 150, green: 150, blue: 150, alpha: 1.0)]
        
        var placeholder : NSMutableAttributedString = NSMutableAttributedString(string: "Email Address")
        placeholder.addAttributes(attributeDictionary, range: NSRange(location: 0, length: placeholder.length))
        self.emailTextField.attributedPlaceholder = placeholder
        
        placeholder = NSMutableAttributedString(string: "Register Number")
        placeholder.addAttributes(attributeDictionary, range: NSRange(location: 0, length: placeholder.length))
        self.registerNumberTextField.attributedPlaceholder = placeholder
        
        placeholder = NSMutableAttributedString(string: "Phone Number")
        placeholder.addAttributes(attributeDictionary, range: NSRange(location: 0, length: placeholder.length))
        self.phoneNumberTextField.attributedPlaceholder = placeholder
        
        // setting delegates of the text fields
        
        self.emailTextField.delegate = self
        self.registerNumberTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        
        // adding tap gesture recognizer to dismiss keyboard
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TwoCreditCourseViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Touch ID - Local authentication
        
        if UserDefaults.standard.bool(forKey: "LoggedIn") != true {
            self.loginUsingTouchID()
        }
        
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.loginButton.layer.cornerRadius = 4.0
        self.emailTextField.layer.cornerRadius = 4.0
        self.registerNumberTextField.layer.cornerRadius = 4.0
        self.phoneNumberTextField.layer.cornerRadius = 4.0
    }
    

    // MARK: - Reachability
    
    func reachabilityChanged() {
        if reachabilityStatus == NOACCESS {
            DispatchQueue.main.async {
                self.present(noInternetAccessAlert(), animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Login
    
    @IBAction func login(_ sender: UIButton) {
        
        if self.emailTextField.text! == "" {
            let animation = CASpringAnimation(keyPath: "position.x")
            animation.fromValue = self.registerNumberTextField.center.x + 10
            animation.toValue = self.registerNumberTextField.center.x
            animation.damping = 6.0
            animation.initialVelocity = 6.0
            animation.stiffness = 1500.0
            animation.duration = animation.settlingDuration
            
            
            self.emailTextField.layer.add(animation, forKey: nil)
            return
        }
        else if self.registerNumberTextField.text! == "" {
            let animation = CASpringAnimation(keyPath: "position.x")
            animation.fromValue = self.registerNumberTextField.center.x + 10
            animation.toValue = self.registerNumberTextField.center.x
            animation.damping = 6.0
            animation.initialVelocity = 6.0
            animation.stiffness = 1500.0
            animation.duration = animation.settlingDuration
            
            
            self.registerNumberTextField.layer.add(animation, forKey: nil)
            return
        }
        else if self.phoneNumberTextField.text! == "" {
            let animation = CASpringAnimation(keyPath: "position.x")
            animation.fromValue = self.registerNumberTextField.center.x + 10
            animation.toValue = self.registerNumberTextField.center.x
            animation.damping = 6.0
            animation.initialVelocity = 6.0
            animation.stiffness = 1500.0
            animation.duration = animation.settlingDuration
            
            
            self.phoneNumberTextField.layer.add(animation, forKey: nil)
            return
        }
        
        self.getFirebaseUserData(false)
        
    }
    
    // MARK: - Text Field
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.emailTextField != textField {
            self.emailTextField.alpha = 0.1
        }
        if self.registerNumberTextField != textField {
            self.registerNumberTextField.alpha = 0.1
        }
        if self.phoneNumberTextField != textField {
            self.phoneNumberTextField.alpha = 0.1
        }
        
        UIView.animate(withDuration: 0.5) { 
            textField.transform = CGAffineTransform.identity.translatedBy(x: 0, y: CGFloat(100 - textField.center.y))
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.emailTextField != textField {
            self.emailTextField.alpha = 1.0
        }
        if self.registerNumberTextField != textField {
            self.registerNumberTextField.alpha = 1.0
        }
        if self.phoneNumberTextField != textField {
            self.phoneNumberTextField.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.5) {
            textField.transform = CGAffineTransform.identity
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
    
    func dismissKeyboard() {
        self.emailTextField.endEditing(true)
        self.registerNumberTextField.endEditing(true)
        self.phoneNumberTextField.endEditing(true)
    }
    
    // MARK: - Mail controller
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([issueEmailAddress])
            mail.setSubject("Login Issue")
            
            self.present(mail, animated: true)
        } else {
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // MARK: - Touch ID 
    
    func loginUsingTouchID() {
        
        
        
        if UserDefaults.standard.bool(forKey: "TouchID") == true {
            
            let authenticationContext = LAContext()
            
            var error: NSError?
            
            guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                return
            }
            
            let email = UserDefaults.standard.object(forKey: "Email") as! String
            
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Login to \(email)",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if( success ) {
                        
                        // Fingerprint recognized
                        // Go to view controller
                        self.emailTextField.text = email
                        self.getFirebaseUserData(true)
                        
                    } else {
                        
                        // Check if there is an error
                        if let error = error {
                            
                            let message = errorMessageForLAErrorCode((error as NSError).code)
                            if message != "None" {
                                self.present(showAlert("Error", message: message), animated: true, completion: nil)
                            }
                            
                        }
                        
                    }
                    
            })
        }
    }
    
        
    // MARK: - Firebase User Data
    
    func getFirebaseUserData(_ touchID: Bool) {
        databaseReference.queryOrdered(byChild: "email").queryEqual(toValue: self.emailTextField.text!).observe(FIRDataEventType.value, with: { (snapshot) in
            
            if snapshot.value is NSNull {
                
                let alertController = showAlert("Sorry!", message: "You are not registered under our two credit course. If you are registered then please send an email")
                alertController.addAction(UIAlertAction(title: "Send Email ", style: UIAlertActionStyle.default, handler: { (action) in
                    self.sendEmail()
                }))
                
                
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                let userData = (snapshot.value! as! [String: AnyObject]).first!.value
                let registerNumber = userData["registerNumber"] as! String
                let phoneNumber = userData["phoneNumber"] as! String
                
                if (self.registerNumberTextField.text! == registerNumber && self.phoneNumberTextField.text! == phoneNumber) || touchID {
                    
                    
                    var user: UserData!
                    
                    if let us = realm.objects(UserData.self).first {
                        user = us
                        
                        let events = userData["events"] as! [String : AnyObject]
                        
                        try! realm.write {
                            
                            realm.delete(realm.objects(Events.self))
                            
                            for event in events {
                                
                                let value = event.value as! [String: AnyObject]
                                
                                let realmEvent = Events()
                                realmEvent.name = value["name"] as! String
                                realmEvent.attended = value["attended"] as! String == "YES" ? true : false
                                realmEvent.date = value["date"] as! String
                                realmEvent.hours = Float((value["hours"] as! NSString).floatValue)
                                
                                user.events.append(realmEvent)
                                
                            }
                            
                        }
                        
                    }
                    else {
                        user = UserData()
                        user.name = userData["name"] as! String
                        user.email = userData["email"] as! String
                        let events = userData["events"] as! [String : AnyObject]
                        
                        for event in events {
                            
                            let value = event.value as! [String: AnyObject]
                            
                            let realmEvent = Events()
                            realmEvent.name = value["name"] as! String
                            realmEvent.attended = value["attended"] as! String == "YES" ? true : false
                            realmEvent.date = value["date"] as! String
                            realmEvent.hours = Float((value["hours"] as! NSString).floatValue)
                            
                            user.events.append(realmEvent)
                            
                        }
                        
                        try! realm.write {
                            realm.add(user)
                        }
                    }
                    
                    
                    UserDefaults.standard.set(true, forKey: "LoggedIn")
                    
                    self.performSegue(withIdentifier: "goToMainPage", sender: self)
                }
                else {
                    self.present(showAlert("Invalid Credentials", message: "The register number and/or the phone number is wrong"), animated: true, completion: nil)
                }
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
}
