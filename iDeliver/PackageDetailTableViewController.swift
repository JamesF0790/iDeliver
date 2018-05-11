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
    
    var isDeleteButtonShown = false// Since the delete button should never be used on a new package it's hidden using the loadPackage() proc only setting this to true if a parcel is loaded

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
        updateAllLabels() // Update the status date/time Labels
        loadPackage() // Try and load the package if it's there
        updateSaveButtonState() // Check if the save button should be enabled
        
    }

    // MARK: - IBActions

    @IBAction func statusDatePickerChanged(_ sender: UIDatePicker) {
        updateDateLabel(label: statusDateLabel, date: sender.date)
    }
    
    @IBAction func statusTimePickerChanged(_ sender: UIDatePicker) {
        updateTimeLabel(label: statusTimeLabel, time: sender.date)
    }
    
    @IBAction func deliveryDatePickerChanged(_ sender: UIDatePicker) {
        deliveryDate = sender.date // Setting this allows me to use it later to check if a date has been set.
        updateDateLabel(label: deliveryDateLabel, date: sender.date)
        updateSaveButtonState() // Updating this is required as I need a date when the parcel has been delivered.
    }
    
    @IBAction func deliveryTimePickerChanged(_ sender: UIDatePicker) {
        deliveryTime = sender.date
        updateTimeLabel(label: deliveryTimeLabel, time: sender.date)
        updateSaveButtonState()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) { // In here I'm getting the user to verify they do want to delete the package as it can't be undone
        let alertController = UIAlertController(title: "Are you sure?", message: "This can not be undone!", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Confirm", style: .destructive) {_ in
            self.performSegue(withIdentifier: "deleteUnwind", sender: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) { // Here I'm telling the app to check if the save button should be enabled after changing a text field
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) { // The text fields hide the keyboard when the user hits return
        sender.resignFirstResponder()
    }
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateSaveButtonState() //This is needed because this proc depends on knowing what the selected index is.
        tableView.beginUpdates() // I've set the delivery date/time fields to hide depending on the status of this control
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath) {
        case [0,1]:
            isStatusDatePickerShown = !isStatusDatePickerShown
            
            statusDateLabel.textColor = isStatusDatePickerShown ? tableView.tintColor : .black
            
            //tableView.beginUpdates()
            //tableView.endUpdates()
        case [0,3]:
            isStatusTimePickerShown = !isStatusTimePickerShown
            
            statusTimeLabel.textColor = isStatusTimePickerShown ? tableView.tintColor : .black
            
            //tableView.beginUpdates()
            //tableView.endUpdates()
        case [2,2]:
            isDeliveryDatePickerShown = !isDeliveryDatePickerShown
            
            deliveryDateLabel.textColor = isDeliveryDatePickerShown ? tableView.tintColor : .black
            
            //tableView.beginUpdates()
            //tableView.endUpdates()
        case [2, 4]:
            isDeliveryTimePickerShown = !isDeliveryTimePickerShown
            
            deliveryTimeLabel.textColor = isDeliveryTimePickerShown ? tableView.tintColor : .black
            
            //tableView.beginUpdates()
            //tableView.endUpdates()
            
        default:
            break
        }
        tableView.beginUpdates()
        tableView.endUpdates()
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
        case [2,2]:// This is where I hide/show the delivery date controls because if it hasn't been delivered there's no need to clutter up the screen with it.
            if (statusSegmentedControl.selectedSegmentIndex == 2 || statusSegmentedControl.selectedSegmentIndex == 3) {
                return normalHeight
            } else {
                isDeliveryDatePickerShown = false
                return hiddenHeight
            }
        case [2,3]:
            return isDeliveryDatePickerShown ? pickerHeight: hiddenHeight

        case [2,4]:
            if (statusSegmentedControl.selectedSegmentIndex == 2 || statusSegmentedControl.selectedSegmentIndex == 3) {
                return normalHeight
            } else {
                isDeliveryTimePickerShown = false
                return hiddenHeight
            }
        case [2,5]:
            return isDeliveryTimePickerShown ? pickerHeight : hiddenHeight
        case[3,0]:
            return notesHeight
        case [4,0]://Hide or show the delete button
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
    
    func updateDateLabel(label: UILabel, date: Date) {// Update a specific date label
        label.text = Package.dateFormatter.string(from: date)
    }
    
    func updateTimeLabel(label: UILabel, time: Date) {// Update as specific time label
        label.text = Package.timeFormatter.string(from: time)
        }
    
    func updateAllLabels() {//Update the status labels and, if the data exists, update the delivery labels
        updateDateLabel(label: statusDateLabel, date: statusDatePicker.date)
        updateTimeLabel(label: statusTimeLabel, time: statusTimePicker.date)
        if let deliveryTime = deliveryTime, let deliveryDate = deliveryDate {
            updateDateLabel(label: deliveryDateLabel, date: deliveryDate)
            updateTimeLabel(label: deliveryTimeLabel, time: deliveryTime)
        }
    }
    
    func loadPackage() { // load the package if possible and enable the delete button
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
    
    func updateSaveButtonState() {// I'm aware this is big and bulky but I couldn't think of a way to quickly reduce it down to a managable size so I'll walk you through my logic
        
        switch statusSegmentedControl.selectedSegmentIndex {// Checking the state of the status segmented control
        case 0:// If it's 0 then the parcel has just been entered so I only need to check two fields
            let nameCheck = recipientNameTextField.text ?? ""//Recipient Name
            let addressCheck = recipientAddressTextField.text ?? ""//and Recipient Address
            
            recipientNameTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Name (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])//Make the placeholder text red to make it clear to the user
            recipientAddressTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Address (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            courierTextField.placeholder = "Courier" //Make sure these are set here so that if the user accidentaly moves to En-Route they don't have these fields stuck in red
            trackingNumberTextField.placeholder = "Tracking Number"
            
            saveButton.isEnabled = !nameCheck.isEmpty && !addressCheck.isEmpty //Check if the two fields have text, if they do make the save button available.
        case 1://If it's 1 then the parcel is En-Route. Now as well as the address and name the user also needs to put in the courier and the tracking number
            let nameCheck = recipientNameTextField.text ?? ""
            let addressCheck = recipientAddressTextField.text ?? ""
            let courierCheck = courierTextField.text ?? ""
            let trackingNoCheck = trackingNumberTextField.text ?? ""
            
            recipientNameTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Name (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            recipientAddressTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Address (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            courierTextField.attributedPlaceholder = NSAttributedString(string: "Courier (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            trackingNumberTextField.attributedPlaceholder = NSAttributedString(string: "Tracking Number (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
             saveButton.isEnabled = !nameCheck.isEmpty && !addressCheck.isEmpty && !courierCheck.isEmpty && !trackingNoCheck.isEmpty//Check all four fields now
        case 2, 3: // If it's 2 or 3 Then delivery has been made, 2 being Delivered and 3 being Returned. Either way we need more info
            let nameCheck = recipientNameTextField.text ?? ""
            let addressCheck = recipientAddressTextField.text ?? ""
            let courierCheck = courierTextField.text ?? ""
            let trackingNoCheck = trackingNumberTextField.text ?? ""
            var dateCheck = ""//Setting these two up now outside the scope of the if statement. I probably should have used guard but this was added late.
            var timeCheck = ""
            if let deliveryDate = deliveryDate {//If possible set them to the string version of the variables I change in the deliveryDate/Time pickers
                dateCheck = Package.dateFormatter.string(from: deliveryDate)
            }
            if let deliveryTime = deliveryTime {
                timeCheck = Package.timeFormatter.string(from: deliveryTime)
            }
            
            recipientNameTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Name (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            recipientAddressTextField.attributedPlaceholder = NSAttributedString(string: "Recipient Address (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            courierTextField.attributedPlaceholder = NSAttributedString(string: "Courier (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            trackingNumberTextField.attributedPlaceholder = NSAttributedString(string: "Tracking Number (Required)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            
            if dateCheck.isEmpty {//If a date hasn't been set then tell the user they have to set one before saving, making the label text red and add (Required)
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
