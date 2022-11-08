//
//  DirectoryViewController.swift
//  BlockTakeHomeAssignment
//
//  Created by Lydia Marion on 05/11/22.
//

import UIKit

enum DirectoryState {
    case successful
    case empty
}

class DirectoryViewController: UITableViewController {
    
    var employees: [Employee] = []
    var employeesImages: [UIImage] = []
    var directoryState: DirectoryState!
    let cellId = "EmployeeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Employee Directory"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEmployees()
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString("Pull to sort by ")
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: Any) {
        loadEmployees()
    }
    
    private func loadEmployees() {
        APIMethods.shared.fetch(.employees) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    let employees = success as! Employees
                    guard let directory = employees.employees else { return }
                    
                    if directory.isEmpty {
                        self.directoryState = .empty
                        self.tableView.setEmptyMessage("Oops... seems like there is no employee information.\n\nI may be a great addition to the team...\njust sayin'...")
                    } else { self.directoryState = .successful }
                    
                    self.employees = directory
                    self.loadEmployeesImages()
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            case .failure:
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: NSLocalizedString("Impossible...", comment: ""),
                                                            message: NSLocalizedString("Perhaps the archives are incomplete", comment: ""),
                                                            preferredStyle: .alert)
                    alertController.addAction(.init(title: NSLocalizedString("OK", comment: ""),
                                                    style: .cancel,
                                                    handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func loadEmployeesImages() {
        for employee in employees {
            self.getImage(url: employee.photoUrlSmall!) { image in
                self.employeesImages.append(image!)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if directoryState == .empty {
            return 0
        } else {
            return employees.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = employees[indexPath.row].fullName
        content.secondaryText = employees[indexPath.row].team
        content.image = employeesImages[indexPath.row]
        content.imageProperties.cornerRadius = 10
        content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        cell.contentConfiguration = content
        return cell
    }
    
    func getImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let img = UIImage(data: data) {
                completion(img)
            } else {
                let placeholder = UIImage(named: "lydia")
                completion(placeholder)
            }
        }.resume()
    }
    
    
}
