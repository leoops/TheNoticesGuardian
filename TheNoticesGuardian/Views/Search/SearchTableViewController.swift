//
//  BuscaTableViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit
import Lottie

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var noticeSearchBar: UISearchBar!
    
    
    let pickerSegue = "pickerSegue"
    let noticeSegue = "searchNoticeSegue"
    let searchNoticeCell = "searchNoticeCell"
    
    var animationView: LOTAnimationView = LOTAnimationView(name: "search");
    var sections = [Int: String]()
    var queryParam: String = ""
    var notices = [SearchResults]()
    var currentPage: Int = 0
    var isRefresh: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.includeAnimation()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchNoticeCell, for: indexPath) as! SearchNoticeTableViewCell
        if  self.notices.count > 0 {
            let notice = self.notices[indexPath.row]
            cell.dateLabel.text = notice.webPublicationDate?.formatToStringDate(oldFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", newFormat: "dd/MM/yyyy' 'HH:mm:ss")
            cell.sectionLabel.text = notice.sectionName
            cell.titleLabel.text = notice.webTitle
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let sectionModalTableViewController = navController.viewControllers.first as? SectionModalTableViewController {
            sectionModalTableViewController.delegate = self
            sectionModalTableViewController.selectedSections = self.sections
        }
        if let noticeViewController = segue.destination as? NoticeViewController, let sender = sender as? String {
            noticeViewController.noticeId = sender
        }

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: noticeSegue, sender: notices[indexPath.row].id)
    }
    
    // MARK: - Request data
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            notices.count != 0 ? requestAndReplaceSearchNotices(queryParam: self.queryParam, section: prepareData()) : nil
        }
    }
    
 
    
    func requestAndReplaceSearchNotices(queryParam: String, section: String) {
        if !isRefresh{
            animationView.playAnimation()
            self.isRefresh = true
            self.currentPage += 1
            let url = LinkManager.listsOfSearchNotices(withQueryParam: queryParam, andPage: "\(self.currentPage)", inSection: section)
            ApiService().resquest(url: url, handler: { response in
                if let response = response {
                    self.animationView.stopAndHidenAnimation()
                    let notices = SearchNotice(object: response)
                    self.notices += notices.results
                    if let pages = notices.pages {
                        self.currentPage < pages ? self.isRefresh = false : nil
                    }
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func prepareData() -> String  {
        var selectedSections = ""
        self.sections.forEach { selectedSections.append("\($0.value)|") }
        selectedSections = "\(selectedSections.dropLast())"
        
        return selectedSections
    }
    
    
    // MARK: - Animation
    
    func includeAnimation(){
        
        animationView.contentMode = .scaleAspectFit
        animationView.frame.size = CGSize(width: 100, height: 100)
        animationView.repositionAnimationOnScreen(positionX: self.view.frame.size.width/2, positionY: self.view.frame.size.height/2)
        
        self.tableView.addSubview(animationView)
        
        animationView.loopAnimation = true
        animationView.isHidden = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        animationView.repositionAnimationOnScreen(positionX: size.width/2, positionY: size.height/2)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        notices.removeAll()
        self.currentPage = 0
        self.tableView.reloadData()
        requestAndReplaceSearchNotices(queryParam: self.queryParam, section: prepareData())
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.queryParam = searchText
    }
}

extension SearchTableViewController: SectionModalTableViewControllerDelegate {
    func selectedSection(selectedSections : [Int : String]) {
        self.sections = selectedSections
        notices.removeAll()
        self.tableView.reloadData()
        self.currentPage = 0
        requestAndReplaceSearchNotices(queryParam: self.queryParam, section: prepareData())
    }
}



