//
//  SessoesTableViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SectionTableViewController: UITableViewController {
    
    typealias JsonSectionHandler = (([SectionResults]?) -> ())
    
    var sections = [SectionResults]()
    let showElement: String = "all"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestSections(element: showElement)
    }
    // MARK: - Table view data
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath) as! SectionTableViewCell
        let section = sections[indexPath.row]
        
        // configuracao da celula
        cell.sectionLabel.text = section.webTitle
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noticesTableViewController = segue.destination as? NoticesTableViewController {
            if let section = sender as? SectionResults {
                noticesTableViewController.selectedSection = section.id
                noticesTableViewController.sectionTitle = section.webTitle
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "noticesSegue", sender: self.sections[indexPath.row])
    }
    
    // MARK: - Data requests
    
    
    /// Requisção das seções apartir da categoria
    ///
    /// - Parameter element: categoria da seção
    func requestSections(element : String ) {
        let url = LinkManager.listOfSections(showElements: element)
        ApiService().resquest(url: url, handler: { response in
            if let response = response {
                let sections  = Section(object: response)
                self.sections = sections.results
                self.tableView.reloadData()
            }
        })
    }
}
