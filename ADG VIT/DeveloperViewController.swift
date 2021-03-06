//
//  DeveloperViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 11/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class DeveloperViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var developerImageView: UIImageView!
    @IBOutlet weak var designerImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // reveal view controller
        
        if revealViewController() != nil {
            self.menuButton.target = revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = SWRevealWidth
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // navigation controller
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.title = "Developers"
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.developerImageView.layer.cornerRadius = self.developerImageView.frame.height / 2.0
        
        self.designerImageView.layer.cornerRadius = self.designerImageView.frame.height / 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
