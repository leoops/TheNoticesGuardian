//
//  FormatData.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 26/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation

class FormatData {
    func AddingPercentEncoding(value : String) -> String {
        if let link = value.addingPercentEncoding(withAllowedCharacters: NSMutableCharacterSet.alphanumeric() as CharacterSet){
            return link
        }
        return ""
    }
}
