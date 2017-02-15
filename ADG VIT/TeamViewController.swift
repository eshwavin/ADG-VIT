//
//  TeamViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 04/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    let names = ["Rishav Shaw", "Pranjal Singh", "Srivinayak Chaitanya Eshwa", "Akhil Ranjan", "Naman Mehta", "Sayantan Pal", "Ruchir Arora", "Shubhendu Dubey", "Pulkit Mittal", "Mantej Gill", "Zeean", "Divyansh Rajput", "Joshua Anith Singh", "Suravi Mishra", "Avantika Bhatia", "Mirunalini Mahamika"]
    
    let designations = ["Director", "President", "Vice President (Technical)", "Vice President (Finance)", "Vice President (Operations)", "General Secretary", "Joint Secretary", "Management Head", "Events Head", "Technical Head", "Projects Head", "Design Head", "Sponsorship Head", "P&M Head", "Public Realtions Officer", "Human Resources"]
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var carouselView: iCarousel!
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.carouselView.decelerationRate = 0.0
        
        self.carouselView.type = .coverFlow
        
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
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.names.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let view = UIView(frame: self.carouselView.frame)
        
        // image
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.carouselView.frame.width, height: self.carouselView.frame.height * 0.84))

        imageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: self.names[index].components(separatedBy: " ").first!.lowercased())
        
        view.addSubview(imageView)
        
        // name
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: self.carouselView.frame.height * 0.84, width: self.carouselView.frame.width, height: self.carouselView.frame.height * 0.1))
        
        nameLabel.textAlignment = .center
        nameLabel.minimumScaleFactor = 0.8
        
        nameLabel.text = self.names[index]
        
        nameLabel.textColor = UIColor.white
        
        nameLabel.font = UIFont(name: "Avenir", size: 19.0)
        
        view.addSubview(nameLabel)
        
        // designation
        
        let designationLabel = UILabel(frame: CGRect(x: 0, y: self.carouselView.frame.height * 0.94, width: self.carouselView.frame.width, height: self.carouselView.frame.height * 0.06))
        
        designationLabel.textAlignment = .center
        
        designationLabel.text = self.designations[index]
        
        designationLabel.textColor = teamColor
        
        designationLabel.font = UIFont(name: "Avenir", size: 15.0)
        
        view.addSubview(designationLabel)
        
        return view
        
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.2
        }
        return value
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
