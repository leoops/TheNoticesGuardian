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
    
    var sections = [SectionResults]()
    var selectedScetions = [Int]()
    weak var delegate: SectionModalTableViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestSections(element: "all")
    }
    
    func requestSections(element : String ) {
        ApiService.requestAllSections(showElements: element, handler: { (items) in
            if let items = items {
                self.sections = items
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

        cell.titleLabel?.text = sections[indexPath.row].webTitle
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedScetions.append(indexPath.row)
        }
    }
    
    @IBAction func selectFilter(_ sender: UIBarButtonItem) {
        delegate?.selectedSection(section: prepareData())
        self.dismiss(animated: true)
    }
    
    func prepareData () -> String {
        var sectionsString = ""
        sectionsString = selectedScetions.reduce(sectionsString, { (selecionadosString, index) -> String in
            return "\(sections[index].id ?? ""),"
        })
        
        return sectionsString
    }

}
