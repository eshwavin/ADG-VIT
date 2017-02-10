//
//  UpcomingEventsViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 03/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class UpcomingEventsViewController: UIViewController {

    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var brochureButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var event: [String: AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventTitleLabel.text = (self.event["name"] as! String)
        
        
        self.eventDescriptionTextView.text = self.event["description"] as! String
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) { 
            self.eventDescriptionTextView.setContentOffset(CGPoint.zero, animated: false)
        }
        
        
        self.eventDateLabel.text = (self.event["date"] as! String)
        
        let contact = (self.event["contact"] as! [String: String])
        let name = contact.first!.key
        let contactNumber = contact.first!.value
        self.contactButton.setTitle(name + ": " + contactNumber, for: UIControlState.normal)
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.exitButton.layer.cornerRadius = self.exitButton.frame.height / 2.0
    }
    
    @IBAction func showBrochure(_ sender: UIButton) {
        
        let URL = self.event["brochureLink"] as! String
        
        let url = NSURL(string: URL) as! URL
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        

    }

    @IBAction func goToRegistrationPage(_ sender: UIButton) {
        
        let URL = self.event["registrationLink"] as! String
        
        if let url = NSURL(string: URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }
    @IBAction func callEventContact(_ sender: UIButton) {
        
        let contact = (self.event["contact"] as! [String: String]).first!.value
        
        let URL = "telprompt://" + contact
        
        if let url = NSURL(string: URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
