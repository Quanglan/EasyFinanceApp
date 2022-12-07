//
//  CalendarViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 27/11/2022.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dataWheelPicker: UIDatePicker!
    var tranDate: Date = Date()
    var passData: (()-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveAction))
        navigationItem.rightBarButtonItem?.isEnabled = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.date = tranDate
        datePicker.backgroundColor = .systemGray6
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 8
        dataWheelPicker.datePickerMode = .date
        dataWheelPicker.preferredDatePickerStyle = .wheels
        dataWheelPicker.date = tranDate
        dataWheelPicker.backgroundColor = .systemGray6
        dataWheelPicker.clipsToBounds = true
        dataWheelPicker.layer.cornerRadius = 8
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveAction() {

        navigationController?.popViewController(animated: true)
        passData?()
    }
    
    @IBAction func selectDatePicker(_ sender: Any) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        tranDate = datePicker.date
        dataWheelPicker.date = datePicker.date
    }
    
    @IBAction func selectDateWheelPicker(_ sender: Any) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        tranDate = dataWheelPicker.date
        datePicker.date = dataWheelPicker.date
    }
    
}
