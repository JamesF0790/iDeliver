
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
            loadSamplePackages() // I had to load a sample into each one to maintain the layout for some reason, couldn't debug it in time so decided to stick with samples
            packages.append(enteredPackages)
            packages.append(enroutePackages)
            packages.append(deliveredPackages)
            packages.append(returnedPackages)
        }
    }

    // MARK : - Unwind
    @IBAction func unwindToPackageList(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! PackageDetailTableViewController
        //Once again I realise the following block is clunky and could probably have been done better with more guard statments but I will explain my logic
        if segue.identifier == "saveUnwind" {//First check which segue called the unwind function and if it was the save segue then carry on
            guard let package = sourceViewController.package else {return} //Set the package property to equal the package from the source view controller
            if let selectedIndexPath = tableView.indexPathForSelectedRow { //This checks if the user got here through an edit or an add by seeing if a row was selected.
                let newStatus = package.status//Get the status integer from the incoming package
                let oldStatus = packages[selectedIndexPath.section][selectedIndexPath.row].status //and from the old package
                if oldStatus == newStatus {//If they're the same then just update it
                    packages[selectedIndexPath.section][selectedIndexPath.row] = package

                } else {//If they aren't then add it into it's new section and array judging from it's status and remove it from the last one
                    let newIndexPath = IndexPath(row: packages[package.status].count, section: package.status)
                    packages[selectedIndexPath.section].remove(at: selectedIndexPath.row)
                    packages[package.status].append(package)
                    tableView.moveRow(at: selectedIndexPath, to: newIndexPath)
                }

            } else {//If the user got here by adding a new parcel and not editing an old one then put it into the right spot using it's status
                let newIndexPath = IndexPath(row: packages[package.status].count, section: package.status)
                packages[package.status].append(package)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        
    } else if segue.identifier == "deleteUnwind" {//Or if it was a delete segue
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {return}//Set the index path to where the parcel originaly came from
            packages[selectedIndexPath.section].remove(at: selectedIndexPath.row)//remove it from the array
            tableView.deleteRows(at: [selectedIndexPath], with: .automatic)//and from the table
        
    }
    tableView.reloadData()//Reload
    Package.savePackages(packages)//And save
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return packages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages[section].count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {//Here is where I set up my header cells. I use these instead of a "status" field in the package cells.
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        
        headerCell.headerLabel.textColor = .black
        
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Entered"
            headerCell.backgroundColor = .cyan //A different color for each one makes the sections distinctive
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
        enroutePackages.append(Package(status: 1, statusDate: Date(), statusTime: Date(), courier: "Bob", trackingNumber: "12345", recipientName: "Jennifer Lane", recipientAddress: "1234 Fake Lane, Los Angeles, 90210, LA", recipientEmail: "JLane@loot.com", recipientPhoneNumber: "555-3123", deliveryDate: Date(), deliveryTime: Date(), notes: "Laney"))
        deliveredPackages.append(Package(status: 2, statusDate: Date(), statusTime: Date(), courier: "Bob", trackingNumber: "123123", recipientName: "John Smith", recipientAddress: "432 False Court, Texarkana, 12131, TX", recipientEmail: "JSmith@smith.com", recipientPhoneNumber: "555-3121", deliveryDate: Date(), deliveryTime: Date(), notes: "Generic"))
        returnedPackages.append(Package(status: 3, statusDate: Date(), statusTime: Date(), courier: "Australia Post", trackingNumber: "AU124125", recipientName: "Jane Doe", recipientAddress: "1 George St Sydney", recipientEmail: "JDoe@gmail.com", recipientPhoneNumber: "0491570156", deliveryDate: Date(), deliveryTime: Date(), notes: nil))
    }
    
}
