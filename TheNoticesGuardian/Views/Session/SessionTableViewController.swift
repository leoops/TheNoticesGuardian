//
//  SessoesTableViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit
import Alamofire

class SessionTableViewController: UITableViewController {
    
    enum ElementSession: String {
        case all = "all"
    }
    
    @IBOutlet weak var sessionButton: UILabel!
    
    var sessions = [SessionResults]()
    var isRefreshing : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestSessions(element: ElementSession.all.rawValue)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Busca de sessoes de noticias
    ///
    /// - Parameter element: tipo de sessao a ser mostrada na listagem
    func requestSessions(element : String ) {
        ApiService.requestAllSessions(showElements: element, handler: { (items) in
            if let items = items {
                self.sessions = items
            }
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sessions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionTableViewCell

        let session = sessions[indexPath.row]
        cell.labelSession.text = session.webTitle
        
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noticesTableViewController = segue.destination as? NoticesTableViewController {
            if let session = sender as? String {
                noticesTableViewController.selectedSession = session
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "noticesSegue", sender: self.sessions[indexPath.row].id)
    }
}
