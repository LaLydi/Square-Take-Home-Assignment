//
//  APICalls.swift
//  BlockTakeHomeAssignment
//
//  Created by Lydia Marion on 05/11/22.
//

import Foundation

public enum HTTPMethod: String {
    case GET
}

public enum APIError: Error {
    case network(Error)
    case missingResponse
    case unexpectedResponse(Int)
    case invalidData
    case invalidJSON(Error)
}

enum APICalls {
    case employees
    case employeesMalformed
    case employeesEmpty
}

extension APICalls {
    var baseURL: URL {
        guard let url = Foundation.URL(string: "https://s3.amazonaws.com/sq-mobile-interview/") else {
            preconditionFailure("Networking call failed")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .employees:
            return "employees.json"
        case .employeesMalformed:
            return "employees_malformed.json"
        case .employeesEmpty:
            return "employees_empty.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .employees, .employeesMalformed, .employeesEmpty:
            return .GET
        }
    }
}
