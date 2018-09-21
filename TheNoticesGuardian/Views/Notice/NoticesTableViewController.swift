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
    
    var url = "https://content.guardianapis.com/<session>?api-key=<apiKey>?show-elementes<shoElements>"
    
    var notices = [NoticesResults]()
    var selectedSession: String? = "books"
    var page: Int = 0
    var pageCurrent: Int? = 1
    var isRefresh: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestAndRefreshOfNotices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func requestAndRefreshOfNotices() {
        if !isRefresh && self.page <= self.pageCurrent! {
            self.isRefresh = true
            self.page += 1
            ApiService.requestNotices(inPage: self.page, withSession: self.selectedSession!, handler: { (newNotices) in
                if let notices = newNotices?.results {
                    self.notices += notices
                }
                self.pageCurrent = newNotices?.page
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
        cell.titleLabel.text = notice.webTitle
        cell.dateLabel.text = notice.webPublicationDate
        
        if let thumbnail = notice.thumbnail {
            let url = URL(string: thumbnail)
            cell.thumbnailImageView.kf.indicatorType = .activity
            cell.thumbnailImageView.kf.setImage(with: url)
        }
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - <#description#>

}
