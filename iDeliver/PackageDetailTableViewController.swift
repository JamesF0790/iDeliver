 //
//  Package DetailTableViewController.swift
//  iDeliver
//
//  Created by James Frost on 7/5/18.
//  Copyright © 2018 James Frost. All rights reserved.
//

import UIKit

class PackageDetailTableViewController: UITableViewController {

    var package: Package?
    
    var isStatusDatePickerShown = false
    var isStatusTimePickerShown = false
    
    var isDeliveryDatePickerShown = false
    var isDeliveryTimePickerShown = false
    
    var isDeleteButtonShown = false

    var deliveryDate: Date?
    var deliveryTime: Date?
    
    // MARK: - Outlets

    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var statusDateLabel: UILabel!
    @IBOutlet weak var statusDatePicker: UIDatePicker!
    @IBOutlet weak var statusTimeLabel: UILabel!
    @IBOutlet weak var statusTimePicker: UIDatePicker!
    
    @IBOutlet weak var courierTextField: UITextField!
    @IBOutlet weak var trackingNumberTextField: UITextField!
    
    @IBOutlet weak var recipientNameTextField: UITextField!
    @IBOutlet weak var recipientAddressTextField: UITextField!
    @IBOutlet weak var recipientPhoneTextField: UITextField!
    @IBOutlet weak var recipientEmailTextField: UITextField!
    
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var deliveryDatePicker: UIDatePicker!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var deliveryTimePicker: UIDatePicker!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAllLabels()
        loadPackage()
        updateSaveButtonState()
        
    }

    // MARK: - IBActions

    @IBAction func statusDatePickerChanged(_ sender: UIDatePicker) {
        updateDateLabel(label: statusDateLabel, date: sender.date)
    }
    
    @IBAction func statusTimePickerChanged(_ sender: UIDatePicker) {
        updateTimeLabel(label: statusTimeLabel, time: sender.date)
    }
    
    @IBAction func deliveryDatePickerChanged(_ sender: UIDatePicker) {
        deliveryDate = sender.date
        updateDateLabel(label: deliveryDateLabel, date: sender.date)
    }
    
    @IBAction func deliveryTimePickerChanged(_ sender: UIDatePicker) {
        deliveryTime = sender.date
        updateTimeLabel(label: deliveryTimeLabel, time: sender.date)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Are you sure?", message: "This can not be undone!", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Confirm", style: .destructive) {_ in
            self.performSegue(withIdentifier: "deleteUnwind", sender: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateSaveButtonState()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath) {
        case [0,1]:
            isStatusDatePickerShown = !isStatusDatePickerShown
            
            statusDateLabel.textColor = isStatusDatePickerShown ? tableView.tintColor : .black
            
            tableView.beginUpdates()
            tableView.endUpdates()
        case [0,3]:
            isStatusTimePickerShown = !isStatusTimePickerShown
            
            statusTimeLabel.textColor = isStatusTimePickerShown ? tableView.tintColor : .black
            
            tableView.beginUpdates()
            tableView.endUpdates()
        case [3,0]:
            isDeliveryDatePickerShown = !isDeliveryDatePickerShown
            
            deliveryDateLabel.textColor = isDeliveryDatePickerShown ? tableView.tintColor : .black
            
            tableView.beginUpdates()
            tableView.endUpdates()
        case [3, 2]:
            isDeliveryTimePickerShown = !isDeliveryTimePickerShown
            
            deliveryTimeLabel.textColor = isDeliveryTimePickerShown ? tableView.tintColor : .black
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let normalHeight = CGFloat(44)
        let pickerHeight = CGFloat(162)
        let hiddenHeight = CGFloat(0)
        let notesHeight = CGFloat(200)
        
        switch (indexPath) {
        case [0,2]:
            return isStatusDatePickerShown ? pickerHeight : hiddenHeight
        case [0,4]:
            return isStatusTimePickerShown ? pickerHeight : hiddenHeight
        case [3,1]:
            return isDeliveryDatePickerShown ? pickerHeight: hiddenHeight
        case [3, 3]:
            return isDeliveryTimePickerShown ? pickerHeight : hiddenHeight
        case[4,0]:
            return notesHeight
        case [5,0]:
            return isDeleteButtonShown ? normalHeight : hiddenHeight
        default:
            return normalHeight
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let status = statusSegmentedControl.selectedSegmentIndex
        let statusDate = statusDatePicker.date
        let statusTime = statusTimePicker.date
        
        let courier = courierTextField.text
        let trackingNo = trackingNumberTextField.text
        
        let recipientName = recipientNameTextField.text!
        let recipientAddress = recipientAddressTextField.text!
        let recipientPhone = recipientPhoneTextField.text!
        let recipientEmail = recipientEmailTextField.text!
        
        let deliveryDate = self.deliveryDate
        let deliveryTime = self.deliveryTime
        
        let notes = notesTextView.text
        
        package = Package(status: status, statusDate: statusDate, statusTime: statusTime, courier: courier, trackingNumber: trackingNo, recipientName: recipientName, recipientAddress: recipientAddress, recipientEmail: recipientEmail, recipientPhoneNumber: recipientPhone, deliveryDate: deliveryDate, deliveryTime: deliveryTime, notes: notes)
    }
    
}
 //MARK: - Private Helper Funcs
private extension PackageDetailTableViewController {
    
    func updateDateLabel(label: UILabel, date: Date) {
        label.text = Package.dateFormatter.string(from: date)
    }
    
    func updateTimeLabel(label: UILabel, time: Date) {
        label.text = Package.timeFormatter.string(from: time)
        }
    
    func updateAllLabels() {
        updateDateLabel(label: statusDateLabel, date: statusDatePicker.date)
        updateTimeLabel(label: statusTimeLabel, time: statusTimePicker.date)
        if let deliveryTime = deliveryTime, let deliveryDate = deliveryDate {
            updateDateLabel(label: deliveryDateLabel, date: deliveryDate)
            updateTimeLabel(label: deliveryTimeLabel, time: deliveryTime)
        }
    }
    
    func loadPackage() {
        if let package = package {
            navigationItem.title = "Edit Package"
            statusSegmentedControl.selectedSegmentIndex = package.status
            statusDatePicker.date = package.statusDate
            statusTimePicker.date = package.statusTime
            courierTextField.text = package.courier ?? ""
            trackingNumberTextField.text = package.trackingNumber ?? ""
            recipientNameTextField.text = package.recipientName
            recipientAddressTextField.text = package.recipientAddress
            recipientEmailTextField.text = package.recipientEmail
            recipientPhoneTextField.text = package.recipientPhoneNumber
            if let deliveryDate = package.deliveryDate, let deliveryTime = package.deliveryTime {
                deliveryDatePicker.date = deliveryDate
                self.deliveryDate = deliveryDate
                deliveryTimePicker.date = deliveryTime
                self.deliveryTime = deliveryTime
            }
            notesTextView.text = package.notes ?? ""
            
            isDeleteButtonShown = true
            deleteButton.backgroundColor = .red
        } else {
            navigationItem.title = "Add Package"
        }
    }
    
    func updateSaveButtonState() {
        
        switch statusSegmentedControl.selectedSegmentIndex {
        case 0:
            let nameCheck = recipientNameTextField.text ?? ""
            let addressCheck = recipientAddressTextField.text ?? ""
            
            recipientNameTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Name (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            recipientAddressTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Address (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            courierTextField.placeholder = "Courier"
            trackingNumberTextField.placeholder = "Tracking Number"
            
            saveButton.isEnabled = !nameCheck.isEmpty && !addressCheck.isEmpty
        case 1:
            let nameCheck = recipientNameTextField.text ?? ""
            let addressCheck = recipientAddressTextField.text ?? ""
            let courierCheck = courierTextField.text ?? ""
            let trackingNoCheck = trackingNumberTextField.text ?? ""
            
            recipientNameTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Name (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            recipientAddressTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Address (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            courierTextField.attributedPlaceholder = NSAttributedString(string: "Courier (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            trackingNumberTextField.attributedPlaceholder = NSAttributedString(string: "Tracking Number (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
             saveButton.isEnabled = !nameCheck.isEmpty && !addressCheck.isEmpty && !courierCheck.isEmpty && !trackingNoCheck.isEmpty
        case 2:
            let nameCheck = recipientNameTextField.text ?? ""
            let addressCheck = recipientAddressTextField.text ?? ""
            let courierCheck = courierTextField.text ?? ""
            let trackingNoCheck = trackingNumberTextField.text ?? ""
            var dateCheck = ""
            var timeCheck = ""
            if let deliveryDate = deliveryDate {
                dateCheck = Package.dateFormatter.string(from: deliveryDate)
            }
            if let deliveryTime = deliveryTime {
                timeCheck = Package.timeFormatter.string(from: deliveryTime)
            }
            
            recipientNameTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Name (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            recipientAddressTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Address (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            courierTextField.attributedPlaceholder = NSAttributedString(string: "Courier (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            trackingNumberTextField.attributedPlaceholder = NSAttributedString(string: "Tracking Number (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            if dateCheck.isEmpty {
                deliveryDateLabel.text = "Not Set (Required)"
                deliveryDateLabel.textColor = .red
            }
            
            if timeCheck.isEmpty {
                deliveryTimeLabel.text = "Not Set (Required)"
                deliveryTimeLabel.textColor = .red
            }
            
            saveButton.isEnabled = !nameCheck.isEmpty && !addressCheck.isEmpty && !courierCheck.isEmpty && !trackingNoCheck.isEmpty && !dateCheck.isEmpty && !timeCheck.isEmpty
            
        default:
            break
        }
    }
}
