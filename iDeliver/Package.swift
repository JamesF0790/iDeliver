//
//  Package.swift
//  iDeliver
//
//  Created by James Frost on 7/5/18.
//  Copyright © 2018 James Frost. All rights reserved.
//

import Foundation

struct Package: Codable {
    
    var status: Int
    var statusDate: Date
    var statusTime: Date
    var courier: String?
    var trackingNumber: String?
    var recipientName: String
    var recipientAddress: String
    var recipientEmail: String?
    var recipientPhoneNumber: String?
    var deliveryDate: Date?
    var deliveryTime: Date?
    var notes: String?
    
}

//MARK: Codable Implementation
extension Package {
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("packages").appendingPathExtension("plist")
    
    static func savePackages(_ packages: [[Package]]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedPackages = try? propertyListEncoder.encode(packages)
        try? codedPackages?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadPackages() -> [[Package]]? {
        guard let codedPackages = try? Data(contentsOf: archiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Array<Package>>.self, from: codedPackages)
    }
}
//MARK: - Date Formatters
extension Package {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

