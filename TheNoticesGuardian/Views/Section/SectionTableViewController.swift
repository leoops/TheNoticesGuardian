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
import Lottie

class SectionTableViewController: UITableViewController {
    
    typealias JsonSectionHandler = (([SectionResults]?) -> ())
    
    var animationView: LOTAnimationView = LOTAnimationView(name: "loader");
    var sections = [SectionResults]()
    let showElement: String = "all"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initiAnimation()
        requestSections(element: showElement)
    }
    // MARK: - Table view data
    
    func initiAnimation(){
        
        animationView.contentMode = .scaleAspectFit
        
        animationView.frame.size = CGSize(width: 100, height: 100)
        animationView.repositionAnimationOnScreen(positionX: self.view.frame.size.width/2, positionY: self.view.frame.size.height/2)
        self.tableView.addSubview(animationView)
        
        animationView.loopAnimation = true
        animationView.play(fromProgress: 0, toProgress: 1, withCompletion: nil)
    } 
    func stopAnimation() {
        animationView.stop()
        animationView.isHidden = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        animationView.repositionAnimationOnScreen(positionX: size.width/2, positionY: size.height/2)
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
        
        // configuracao da celula
        cell.sectionLabel.text = section.webTitle
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noticesTableViewController = segue.destination as? NoticesTableViewController {
            if let section = sender as? SectionResults {
                if let id = section.id { noticesTableViewController.selectedSection = id }
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
                self.stopAnimation()
            }
        })
    }
}
