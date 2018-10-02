//
//  SessaoTableViewCell.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupLayer()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupLayer() {
        self.sectionLabel.text = ""
        self.sectionLabel.cornerRadius = (self.sectionLabel.frame.size.height/2)
        self.sectionLabel.clipsToBounds = true
    }
}
