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
    
    var section: String = "about"
    var queryParam: String = ""
    var noticesResult = [SearchResults]()
    var sections = [SectionResults]()
    var pages: Int? = 1
    var currentPage: Int? = 0
    var isRefresh: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func newRequestSearchNotices(queryParam: String, section: String) {
        ApiService.requestOfSearchNotice(withQueryParam: queryParam, andPage: 1, inSection: section,  handler: { (newNotices) in
            if let notices = newNotices{
                self.noticesResult = notices.results
                self.pages = notices.pages
                self.currentPage = notices.currentPage
            }
            self.tableView.reloadData()
        })
    }
    
    func requestAndReplaceSearchNotices(queryParam: String, section: String) {
        
        if !isRefresh{
            self.isRefresh = true
            self.currentPage = self.currentPage! + 1
            ApiService.requestOfSearchNotice(withQueryParam: queryParam, andPage: self.currentPage! + 1, inSection: section,  handler: { (newNotices) in
                if let notices = newNotices{
                    self.noticesResult += notices.results
                    self.pages = notices.pages
                    self.currentPage = notices.currentPage
                }
                self.tableView.reloadData()
                self.isRefresh = false
            })
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticesResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchNoticeCell", for: indexPath) as! SearchNoticeTableViewCell

        let notice = self.noticesResult[indexPath.row]
        cell.dateLabel.text = notice.webPublicationDate
        cell.sectionLabel.text = notice.sectionName
        cell.titleLabel.text = notice.webTitle

        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            requestAndReplaceSearchNotices(queryParam: self.queryParam, section: self.section)
        }
    }

    
    @IBAction func filterButton(_ sender: Any) {
        self.performSegue(withIdentifier: pickerSegue, sender: Any?.self )
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "pickerSegue":
            if let pickerViewController = segue.destination as? PickerViewController {
                pickerViewController.delegate = self
            }
        default:
            if let noticeViewController = segue.destination as? NoticeViewController {
                if let sender = sender as? String {
                    noticeViewController.noticeId = sender
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: noticeSegue, sender: noticesResult[indexPath.row].id)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        newRequestSearchNotices(queryParam: self.queryParam, section: self.section)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.queryParam = searchText
    }
}

extension SearchTableViewController: PickerViewControllerDelegate {
    func selectedSection(section: String) {
        self.section = section
        print(section)
    }
}

