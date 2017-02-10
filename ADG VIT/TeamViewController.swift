//
//  TeamViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 04/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController{
    
    let names = ["Rishav Shaw", "Pranjal Singh", "Srivinayak Chaitanya Eshwa", "Akhil Ranjan", "Naman Mehta", "Sayantan Pal", "Ruchir Arora", "Shubhendu Dubey", ""]
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.title = "Our Team"
        
        
        
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
