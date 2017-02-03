//
//  EventsInnerCollectionViewCell.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 02/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class EventsInnerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    var event: [String: AnyObject] = [:] {
        didSet {
            updateCell()
        }
    }
    
    
    func updateCell() {
        
        if let desc = self.event["description"] as? String {
            
            self.eventDetailsTextView.text = desc
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001, execute: { 
                self.eventDetailsTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
            })
        }
        
        if let name = self.event["name"] as? String {
            self.eventNameLabel.text = name
        }
        
        if let date = self.event["date"] as? String {
            self.eventDateLabel.text = date
        }
        
    }
    
}
