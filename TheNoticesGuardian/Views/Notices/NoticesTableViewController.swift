//
//  NoticiasTableViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class NoticesTableViewController: UITableViewController {
    
   let noticeSegue = "noticeSegue"

    var notices = [NoticesResults]()
    var animationView: LOTAnimationView = LOTAnimationView(name: "loader");
    var selectedSection: String = ""
    var sectionTitle: String?
    
    var isRefresh: Bool = false
    var currentPage: Int = 0
    var page: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = sectionTitle
        
        self.includeAnimation()
        self.requestAndRefreshOfNotices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Data request

    /// Requisição de noticias com atualização da tela
    func requestAndRefreshOfNotices() {
        if !isRefresh{
            animationView.playAnimation()
            self.isRefresh = true
            self.currentPage += 1
            let url = LinkManager.listOfNotices(section: self.selectedSection, pageNumber: "\(self.currentPage)")
            
            ApiService().resquest(url: url, handler: { (response) in
                if let response = response {
                    let notices  = Notices(object: response)
                    self.notices += notices.results
                    if let pages = notices.pages {
                        self.currentPage < pages ? self.isRefresh = false : nil
                    }
                    self.animationView.stopAndHidenAnimation()
                    self.tableView.reloadData()
                }
                
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
        cell.dateLabel.text = notice.webPublicationDate?.formatToStringDate(oldFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'", newFormat: "dd/MM/yyyy' 'HH:mm:ss")
        
        if let thumbnail = notice.thumbnail {
            cell.thumbnailImageView.kf.indicatorType = .activity
            cell.thumbnailImageView.kf.setImage(with: URL(string: thumbnail))
        }
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 100 {
            if notices.count != 0 {
                requestAndRefreshOfNotices()
            }
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
        return 0.0001
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
