//
//  ProjectDetailsViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 02/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class ProjectDetailsViewController: UIViewController {

    var project: [String: String]?
    
    @IBOutlet weak var projectImageView: UIImageViewAligned!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectTitleHead: UIView!
    @IBOutlet weak var projectTitleHeadLabel: UILabel!
    @IBOutlet weak var projectTextView: UITextView!
    
    @IBOutlet weak var iOSButton: UIButton!
    @IBOutlet weak var androidButton: UIButton!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var imageHideRevealButton: UIButton!

    @IBOutlet weak var projectImageViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Changes
        
        self.projectImageView.alignTop = true
        
        self.projectTitleHeadLabel.text = self.project!["name"]
        self.projectTitle.text = self.project!["name"]
        self.projectTextView.text = self.project!["description"]
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) { 
            self.projectTextView.setContentOffset(CGPoint.zero, animated: false)
        }
        
        // reachability
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reachabilityChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        self.reachabilityChanged()
        
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.exitButton.layer.cornerRadius = self.exitButton.frame.height / 2.0
        self.imageHideRevealButton.layer.cornerRadius = self.imageHideRevealButton.frame.height / 2.0
    }
    
    // MARK: - Support Functions
    
    @IBAction func changeHeight(_ sender: UIButton) {
        
        if self.projectImageViewHeightConstraint.constant == 0 {
            self.projectImageViewHeightConstraint.constant = (self.view.frame.height) * 0.6
        }
        else {
            self.projectImageViewHeightConstraint.constant = 0
            
        }
        
        
        UIView.animate(withDuration: 1.0) {
            
            if self.projectTitleHead.alpha == 0 {
                self.projectTitleHead.alpha = 1
            }
            else {
                self.projectTitleHead.alpha = 0
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    func reachabilityChanged() {
        if reachabilityStatus == NOACCESS {
            self.present(noInternetAccessAlert(), animated: true, completion: nil)
        }
        else if self.projectImageView.image == nil {
            DataManager().getProjectsImage(url: "\(project!["imagePath"]!).png") { (image) in
                self.projectImageView.image = image
            }
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
