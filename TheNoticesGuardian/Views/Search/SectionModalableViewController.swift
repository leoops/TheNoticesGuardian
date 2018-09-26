//
//  PickerTableViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 25/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit

protocol SectionModalTableViewControllerDelegate: class {
    func selectedSection(section: String)
    
}
class SectionModalTableViewController: UITableViewController {

    let sectionModalCell = "sectionModalCell"
    
    var sectionsString = ""
    var sections = [SectionResults]()
    var selectedSections = [Int]()
    weak var delegate: SectionModalTableViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestSections(element: "all")
    }
    
    func requestSections(element : String ) {
        ApiService.requestAllSections(showElements: element, handler: { (items) in
            if let items = items {
                self.sections.append(SectionResults(id: "", webTitle: "All", apiUrl: ""))
                self.sections += items
            }
            self.tableView.reloadData()
        })
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

        switch indexPath.row {
        case 0:
            cell.titleLabel?.text = sections[indexPath.row].webTitle
        default:
            cell.titleLabel?.text = sections[indexPath.row].webTitle
            let  selectedRow = selectedSections.contains(indexPath.row)
            if selectedRow == true {
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
                    
                } else if let selectedIndex = selectedSections.index(where: {$0 == indexPath.row}) {
                    selectedSections.remove(at: selectedIndex)
                    cell.accessoryType = .none
                }
            } else if cell.accessoryType == .none {
                if indexPath.row == 0 {
                    selectedSections.removeAll()
                    let cells = self.tableView.visibleCells
                    cells.forEach{ $0.accessoryType = .checkmark }
                    for (index, _) in sections.enumerated() {
                        if index != 0 { selectedSections.append(index) }
                    }
                } else {
                    cell.accessoryType = .checkmark
                    selectedSections.append(indexPath.row)
                }
            }
        }
    }
    
    @IBAction func selectFilter(_ sender: UIBarButtonItem) {
        delegate?.selectedSection(section: prepareData())
        self.dismiss(animated: true)
    }
    
    func prepareData() -> String {
        
        
        
        selectedSections.forEach(){
            if let id = sections[$0].id {
                sectionsString.append("\(id)|")
            }
        }
        sectionsString = String(sectionsString.dropLast())
        return sectionsString
    }

}
