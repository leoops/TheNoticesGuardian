//
//  NoticiasTableViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit
import Kingfisher

class NoticesTableViewController: UITableViewController {
    
   let noticeSegue = "noticeSegue"

    var notices = [NoticesResults]()
    var selectedSection: String?
    var isRefresh: Bool = false
    var pageCurrent: Int? = 1
    var page: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestAndRefreshOfNotices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Data request
    
    func requestAndRefreshOfNotices() {
        
        if !isRefresh && self.page <= self.pageCurrent! {
            self.isRefresh = true
            self.page += 1
            ApiService.requestNotices(inPage: self.page, withSection: self.selectedSection!, handler: { (newNotices) in
                if let notices = newNotices?.results {
                    self.notices += notices
                }
                self.pageCurrent = newNotices?.pages
                self.tableView.reloadData()
                self.isRefresh = false
            })
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as! NoticeTableViewCell
        
        let notice = notices[indexPath.row]
        
        if let thumbnail = notice.thumbnail {
            let url = URL(string: thumbnail)
            cell.thumbnailImageView.kf.indicatorType = .activity
            cell.thumbnailImageView.kf.setImage(with: url)
        }
        
        cell.titleLabel.text = notice.webTitle
        cell.dateLabel.text = notice.webPublicationDate
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            requestAndRefreshOfNotices()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noticeViewController = segue.destination as? NoticeViewController {
            if let sender = sender as? String {
                noticeViewController.noticeId = sender
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: noticeSegue, sender: notices[indexPath.row].id)
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

}
