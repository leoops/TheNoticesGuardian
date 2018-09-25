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
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialConfig()
        requestNotice(id: noticeId!)
    }
    
    func requestNotice(id: String) {
        ApiService.requestNotice(withId: id, handler: { (item) in
            if let notice = item {
                self.dateLabel.text = notice.webPublicationDate
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
