//
//  APIMethods.swift
//  BlockTakeHomeAssignment
//
//  Created by Lydia Marion on 05/11/22.
//

import Foundation

class APIMethods {
    
    static let shared = APIMethods()
    let session = URLSession.shared
    
    func fetch(_ call: APICalls, completion: @escaping(Result<Any, APIError>) -> Void) {
        let url = call.baseURL.appendingPathComponent(call.path)
        var request = URLRequest(url: url)
        
        request.httpMethod = call.method.rawValue
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.network(error!)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.missingResponse))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(.unexpectedResponse(response.statusCode)))
                return
            }
            
            guard let receivedData = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                switch call {
                case .employees, .employeesMalformed, .employeesEmpty:
                    let result = try decoder.decode(Employees.self, from: receivedData)
                    completion(.success(result))
                }
            } catch {
                completion(.failure(.invalidJSON(error)))
            }
        }
        
        task.resume()
    }
}
