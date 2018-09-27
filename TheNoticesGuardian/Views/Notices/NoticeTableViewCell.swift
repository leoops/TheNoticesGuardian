//
//  NoticiaTableViewCell.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setupCell() {
        self.thumbnailImageView.layer.cornerRadius = self.thumbnailImageView.frame.size.height/2
        self.thumbnailImageView.clipsToBounds = true
        self.titleLabel.text = ""
        self.dateLabel.text = ""

    }
}
