//
//  BuscaTableViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var noticeSearchBar: UISearchBar!
    
    
    let pickerSegue = "pickerSegue"
    let noticeSegue = "searchNoticeSegue"
    let searchNoticeCell = "searchNoticeCell"
    
    var section: String? = ""
    var queryParam: String? = ""
    var notices = [SearchResults]()
    var currentPage: Int? = 0
    var isRefresh: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let notice = self.notices[indexPath.row]
        
        cell.dateLabel.text = notice.webPublicationDate?.formatDate(oldFormat: "yyyy-MM-dd'T'HH:mm:ssZ", newFormat: "dd/MM/yyyy' 'HH:mm:ss")
        cell.sectionLabel.text = notice.sectionName
        cell.titleLabel.text = notice.webTitle
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
   
    
    @IBAction func filterButton(_ sender: Any) {
        self.performSegue(withIdentifier: pickerSegue, sender: Any?.self )
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let pickerTableViewController = navController.viewControllers.first as? SectionModalTableViewController {
            pickerTableViewController.delegate = self
        }
        if let noticeViewController = segue.destination as? NoticeViewController {
            if let sender = sender as? String {
                noticeViewController.noticeId = sender
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: noticeSegue, sender: notices[indexPath.row].id)
    }
    
    // MARK: - Request data
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            if (notices.count != 0) {
                requestAndReplaceSearchNotices(queryParam: self.queryParam!, section: self.section!)
            }
        }
    }
    
    func newRequestSearchNotices(queryParam: String, section: String) {
        self.notices.removeAll()
        ApiService.requestOfSearchNotice(withQueryParam: queryParam, andPage: 1, inSection: section,  handler: { (newNotices) in
            if let notices = newNotices{
                self.notices = notices.results
                self.currentPage = notices.currentPage
            }
            self.tableView.reloadData()
        })
    }
    
    func requestAndReplaceSearchNotices(queryParam: String, section: String) {
        if !isRefresh{
            self.isRefresh = true
            self.currentPage = self.currentPage! + 1
            ApiService.requestOfSearchNotice(withQueryParam: queryParam, andPage: self.currentPage!, inSection: section,  handler: { (newNotices) in
                if let notices = newNotices{
                    self.notices += notices.results
                    if self.currentPage! < notices.pages! {
                        self.isRefresh = false
                    }
                }
                self.tableView.reloadData()
                
            })
        }
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        newRequestSearchNotices(queryParam: self.queryParam!, section: self.section!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.queryParam = searchText
    }
}

extension SearchTableViewController: SectionModalTableViewControllerDelegate {
    func selectedSection(section: String) {
        self.section = section
        notices.removeAll()
        requestAndReplaceSearchNotices(queryParam: self.queryParam!, section: self.section!)
    }
}

