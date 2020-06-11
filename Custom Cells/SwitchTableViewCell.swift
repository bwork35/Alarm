//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Bryan Workman on 6/8/20.
//  Copyright © 2020 Bryan Workman. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func switchCellSwitchValueChanged(for cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    var alarm: Alarm?
    
    
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellSwitchValueChanged(for: self)
    }
    
    
    func updateViews(with alarm: Alarm){
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.isOn
    }
}
