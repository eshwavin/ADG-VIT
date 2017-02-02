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
        
    }
    
}
