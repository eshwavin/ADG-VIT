//
//  ProjectsInnerCollectionViewCell.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 02/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class ProjectsInnerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var projectDetailsTextView: UITextView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectTypeImage: UIImageView!
    
    var project: [String: String] = [:] {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        if let desc = self.project["description"] {
            self.projectDetailsTextView.text = desc
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001, execute: { 
                self.projectDetailsTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
//                self.projectDetailsTextView.setContentOffset(CGPoint.zero, animated: false)
            })
            
        }
        
        if let name = self.project["name"] {
            self.projectNameLabel.text = name
        }
        
        if let imageName = self.project["imageType"] {
            self.projectTypeImage.image = UIImage(named: imageName)
        }
        
    }
    
}
