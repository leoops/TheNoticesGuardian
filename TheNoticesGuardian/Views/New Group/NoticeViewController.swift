//
//  NoticeViewController.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 19/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit
import Kingfisher
class NoticeViewController: UIViewController {
    
    var noticeId: String?
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var bodyLabel: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialConfig()
        if let noticeId = self.noticeId { requestNotice(id: noticeId) }
    }
    
    /// Requisição da noticia aparti do id
    ///
    /// - Parameter id: codigo da noticia
    func requestNotice(id: String) {
        let url = LinkManager.itemNotice(id: id)
        ApiService().resquest(url: url, handler: { (response) in
            if let response = response {
                let notice = Notice(object: response)
                self.dateLabel.text = notice.webPublicationDate?.formatToStringDate(oldFormat: "yyyy-MM-dd'T'HH:mm:ssZ", newFormat: "dd/MM/yyyy' 'HH:mm:ss")
                self.sectionLabel.text = notice.sectionName
                self.titleLabel.text = notice.webTitle
                self.bodyLabel.text = notice.bodyText
                if let thumbnail = notice.thumbnail, let url = URL(string: thumbnail) {
                    self.thumbnailImageView.kf.indicatorType = .activity
                    self.thumbnailImageView.kf.setImage(with: url)
                }
            }
        })
    }
    
    func initialConfig() {
        self.bodyLabel.text = ""
        self.dateLabel.text = ""
        self.sectionLabel.text = ""
        self.titleLabel.text = ""
    }
}
