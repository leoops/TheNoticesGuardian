//
//  PickerTableViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 25/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit

protocol SectionModalTableViewControllerDelegate: class {
    func selectedSection(selectedSections: [Int: String])
    
}
class SectionModalTableViewController: UITableViewController {

    let sectionModalCell = "sectionModalCell"
    
    var sections = [SectionResults]()
    var selectedSections = [Int : String]()
    weak var delegate: SectionModalTableViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestSections(element: "all")
    }
    
    func reselectSections() {
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sectionModalCell, for: indexPath) as! SectionModalTableViewCell
        
        // configure cells
        switch indexPath.row {
        case 0:
            cell.titleLabel?.text = sections[indexPath.row].webTitle
        default:
            cell.titleLabel?.text = sections[indexPath.row].webTitle
            
            let selectedRow = selectedSections.contains { $0.key == indexPath.row }
            
            if selectedRow {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                if indexPath.row == 0 {
                    let cells = self.tableView.visibleCells
                    cells.forEach{ $0.accessoryType = .none }
                    selectedSections.removeAll()
                } else {
                    selectedSections.removeValue(forKey: indexPath.row)
                    cell.accessoryType = .none
                }
            } else if cell.accessoryType == .none {
                if indexPath.row == 0 {
                    let cells = self.tableView.visibleCells
                    
                    selectedSections.removeAll()
                    for (index, value) in sections.enumerated() {
                        index != 0 ? selectedSections[index] = value.id : nil
                    }
                    cells.forEach{ $0.accessoryType = .checkmark }
                } else {
                    selectedSections[indexPath.row] = self.sections[indexPath.row].id
                    cell.accessoryType = .checkmark
                }
            }
        }
    }
    
    // MARK: - Data request
    
    func requestSections(element : String ) {
        ApiService.requestAllSections(showElements: element, handler: { (items) in
            if let items = items {
                self.sections.append(SectionResults(id: "", webTitle: "All", apiUrl: ""))
                self.sections += items
            }
            self.tableView.reloadData()
        })
    }

    // MARK: - Navigation
    
    @IBAction func selectFilter(_ sender: UIBarButtonItem) {
        delegate?.selectedSection(selectedSections: selectedSections)
        self.dismiss(animated: true)
    }
}
