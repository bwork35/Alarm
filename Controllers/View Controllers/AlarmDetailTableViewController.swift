//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Bryan Workman on 6/8/20.
//  Copyright © 2020 Bryan Workman. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmButtonLabel: UIButton!
    
    var alarm: Alarm?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }

    //MARK: Buttons
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else {return}
        if alarm.isOn {
            alarmButtonLabel.setTitle("Turn Off", for: .normal)
        } else {
            alarmButtonLabel.setTitle("Turn On", for: .normal)
        }
        alarm.isOn = !alarm.isOn
        updateViews()
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        if alarm != nil {
            let datePicked = datePicker.date
            let isEnabled = alarmButtonLabel.isEnabled
            guard let alarmName = alarmNameTextField.text, let theAlarm = alarm else {return}
            AlarmController.shared.update(alarm: theAlarm, fireDate: datePicked, name: alarmName, enabled: isEnabled)
        } else {
            let datePicked = datePicker.date
            let isEnabled = alarmButtonLabel.isEnabled
            guard let alarmName = alarmNameTextField.text else {return}
            AlarmController.shared.addAlarm(fireDate: datePicked, name: alarmName, enabled: isEnabled)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Table view data source
    
    private func updateViews() {
        guard let alarm = alarm else {return}
        alarmNameTextField.text = alarm.name
        datePicker.date = alarm.fireDate
        
        if alarm.isOn {
            //alarm.isOn = true
            alarmButtonLabel.setTitle("Turn Off", for: .normal)
        } else {
            //alarm.isOn = false
            alarmButtonLabel.setTitle("Turn On", for: .normal)
        }
        
    }
    
}
