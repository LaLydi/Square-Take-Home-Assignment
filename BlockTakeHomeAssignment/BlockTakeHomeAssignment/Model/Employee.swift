//
//  Employee.swift
//  BlockTakeHomeAssignment
//
//  Created by Lydia Marion on 05/11/22.
//

import Foundation

// MARK: - Employees
struct Employees: Codable {
    var employees: [Employee]?

    enum CodingKeys: String, CodingKey {
        case employees = "employees"
    }
}

// MARK: - Employee
struct Employee: Codable {
    var uuid: String
    var fullName: String?
    var phoneNumber: String?
    var emailAddress: String?
    var biography: String?
    var photoUrlSmall: URL?
    var photoUrlLarge: URL?
    var team: String?
    var employeeType: EmployeeType?

    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography = "biography"
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
        case team = "team"
        case employeeType = "employee_type"
    }
}

enum EmployeeType: String, Codable {
    case contractor = "CONTRACTOR"
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
}
