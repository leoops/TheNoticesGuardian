//
//  SessoesTableViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit
import Alamofire

class SectionTableViewController: UITableViewController {
    
    enum ElementSection: String {
        case all = "all"
    }
    
    var sections = [SectionResults]()
    var isRefreshing : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestSections(element: ElementSection.all.rawValue)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestSections(element : String ) {
        ApiService.requestAllSections(showElements: element, handler: { (items) in
            if let items = items {
                self.sections = items
            }
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath) as! SectionTableViewCell

        let section = sections[indexPath.row]
        cell.sectionLabel.text = section.webTitle
        
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noticesTableViewController = segue.destination as? NoticesTableViewController {
            if let section = sender as? String {
                noticesTableViewController.selectedSection = section
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "noticesSegue", sender: self.sections[indexPath.row].id)
    }
}
