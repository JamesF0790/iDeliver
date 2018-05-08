
import UIKit

class PackageTableViewController: UITableViewController {

    var enteredPackages: [Package] = []
    var enroutePackages: [Package] = []
    var deliveredPackages: [Package] = []
    var packages: [[Package]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedPackages = Package.loadPackages() {
            packages = savedPackages
        } else {
            packages.append(enteredPackages)
            packages.append(enroutePackages)
            packages.append(deliveredPackages)
        }
        //loadSamplePackages()
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
                        tableView.reloadData()
                    } else {
                        let newIndexPath = IndexPath(row: packages[package.status].count, section: package.status)
                        packages[selectedIndexPath.section].remove(at: selectedIndexPath.row)
                        packages[package.status].append(package)
                        tableView.moveRow(at: selectedIndexPath, to: newIndexPath)
                        tableView.reloadData()
                    }

                } else {
                    let newIndexPath = IndexPath(row: packages[package.status].count, section: package.status)
                    packages[package.status].append(package)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                    tableView.reloadData()
                }
            }
        } else if segue.identifier == "deleteUnwind" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                packages[selectedIndexPath.section].remove(at: selectedIndexPath.row)
                tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
                tableView.reloadData()
            }
        }
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
        
        headerCell.backgroundColor = .cyan
        
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Entered"
        case 1:
            headerCell.headerLabel.text = "En-Route"
        case 2:
            headerCell.headerLabel.text = "Delivered"
        default:
            headerCell.headerLabel.text = "Other"
        }
        
        return headerCell
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "packageCell", for: indexPath) as! PackageCell

        cell.nameLabel?.text = packages[indexPath.section][indexPath.row].recipientName
        cell.addressLabel?.text = packages[indexPath.section][indexPath.row].recipientAddress
        print(indexPath)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
/* private extension PackageTableViewController {
    func loadSamplePackages() {
        
        enteredPackages.append(Package(status: 0, statusDate: Date(), statusTime: Date(), courier: "Bob", trackingNumber: "12312", recipientName: "Joe Blogs", recipientAddress: "123 Fake Street New York, 12412, NY", recipientEmail: "JoeBlogs@blogsy.com", recipientPhoneNumber: "555-3931", deliveryDate: Date(), deliveryTime: Date(), notes: "Blogsy"))
        enroutePackages.append(Package(status: 1, statusDate: Date(), statusTime: Date(), courier: "Bob", trackingNumber: "12345", recipientName: "Jane Doe", recipientAddress: "1234 Fake Lane, Los Angeles, 90210, LA", recipientEmail: "JLane@loot.com", recipientPhoneNumber: "555-3123", deliveryDate: Date(), deliveryTime: Date(), notes: "Laney"))
        deliveredPackages.append(Package(status: 2, statusDate: Date(), statusTime: Date(), courier: "Bob", trackingNumber: "123123", recipientName: "John Smith", recipientAddress: "432 False Court, Texarkana, 12131, TX", recipientEmail: "JSmith@smith.com", recipientPhoneNumber: "555-3121", deliveryDate: Date(), deliveryTime: Date(), notes: "Generic"))
    }
}
*/
