
import UIKit

class PackageTableViewController: UITableViewController {

    var enteredPackages: [Package] = [] // The first four arrays are only used to set up the fifth array's contents
    var enroutePackages: [Package] = []
    var deliveredPackages: [Package] = []
    var returnedPackages: [Package] = []
    var packages: [[Package]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedPackages = Package.loadPackages() {
            packages = savedPackages
        } else {
            loadSamplePackages() // I had to load a sample into each one or 
            packages.append(enteredPackages)
            packages.append(enroutePackages)
            packages.append(deliveredPackages)
            packages.append(returnedPackages)
        }
    }

    // MARK : - Unwind
    @IBAction func unwindToPackageList(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! PackageDetailTableViewController
        
        if segue.identifier == "saveUnwind" {
            if let package = sourceViewController.package {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    let newStatus = package.status
                    let oldStatus = packages[selectedIndexPath.section][selectedIndexPath.row].status
                    if oldStatus == newStatus {
                        packages[selectedIndexPath.section][selectedIndexPath.row] = package

                    } else {
                        let newIndexPath = IndexPath(row: packages[package.status].count, section: package.status)
                        packages[selectedIndexPath.section].remove(at: selectedIndexPath.row)
                        packages[package.status].append(package)
                        tableView.moveRow(at: selectedIndexPath, to: newIndexPath)
                    }

                } else {
                    let newIndexPath = IndexPath(row: packages[package.status].count, section: package.status)
                    packages[package.status].append(package)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        } else if segue.identifier == "deleteUnwind" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                packages[selectedIndexPath.section].remove(at: selectedIndexPath.row)
                tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
            }
        }
        tableView.reloadData()
        Package.savePackages(packages)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return packages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages[section].count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        
        headerCell.headerLabel.textColor = .black
        
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Entered"
            headerCell.backgroundColor = .cyan
        case 1:
            headerCell.headerLabel.text = "En-Route"
            headerCell.backgroundColor = .yellow
        case 2:
            headerCell.headerLabel.text = "Delivered"
            headerCell.backgroundColor = .green
        case 3:
            headerCell.headerLabel.text = "Returned"
            headerCell.backgroundColor = .red
            headerCell.headerLabel.textColor = .white
        default:
            headerCell.headerLabel.text = "Other"
        }
        
        return headerCell
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "packageCell", for: indexPath) as! PackageCell

        cell.nameLabel?.text = packages[indexPath.section][indexPath.row].recipientName
        cell.addressLabel?.text = packages[indexPath.section][indexPath.row].recipientAddress
        
        switch (indexPath.section) {

        case 3:
            cell.nameLabel.textColor = .red
            cell.addressLabel.textColor = .red
            
        default:
            cell.nameLabel.textColor = .black
            cell.addressLabel.textColor = .black
        }
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEdit" {
            let packageDetailTableViewController = segue.destination as! PackageDetailTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let package = packages[indexPath.section][indexPath.row]
            packageDetailTableViewController.package = package
        }
    }
}
private extension PackageTableViewController {
    func loadSamplePackages() {
        
        enteredPackages.append(Package(status: 0, statusDate: Date(), statusTime: Date(), courier: "Bob", trackingNumber: "12312", recipientName: "Joe Blogs", recipientAddress: "123 Fake Street New York, 12412, NY", recipientEmail: "JoeBlogs@blogsy.com", recipientPhoneNumber: "555-3931", deliveryDate: Date(), deliveryTime: Date(), notes: "Blogsy"))
        enroutePackages.append(Package(status: 1, statusDate: Date(), statusTime: Date(), courier: "Bob", trackingNumber: "12345", recipientName: "Jane Doe", recipientAddress: "1234 Fake Lane, Los Angeles, 90210, LA", recipientEmail: "JLane@loot.com", recipientPhoneNumber: "555-3123", deliveryDate: Date(), deliveryTime: Date(), notes: "Laney"))
        deliveredPackages.append(Package(status: 2, statusDate: Date(), statusTime: Date(), courier: "Bob", trackingNumber: "123123", recipientName: "John Smith", recipientAddress: "432 False Court, Texarkana, 12131, TX", recipientEmail: "JSmith@smith.com", recipientPhoneNumber: "555-3121", deliveryDate: Date(), deliveryTime: Date(), notes: "Generic"))
        returnedPackages.append(Package(status: 3, statusDate: Date(), statusTime: Date(), courier: nil, trackingNumber: nil, recipientName: "James Frost", recipientAddress: "403 Tarakan Ave", recipientEmail: nil, recipientPhoneNumber: nil, deliveryDate: nil, deliveryTime: nil, notes: nil))
    }
    
}
