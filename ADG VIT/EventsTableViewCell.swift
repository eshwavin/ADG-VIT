//
//  EventsTableViewCell.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 11/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    var event: Events = Events() {
        didSet {
            self.updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        
        self.nameLabel.text = self.event.name
        self.dateLabel.text = self.event.date
        self.hoursLabel.text = "\(self.event.hours) Hours"
        if self.event.attended {
            self.hoursLabel.textColor = attendedColor
        }
        else {
            self.hoursLabel.textColor = absentColor
        }
        
    }

}
