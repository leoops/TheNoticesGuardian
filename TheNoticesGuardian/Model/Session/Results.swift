//
//  Results.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 20/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwiftyJSON



class Results {
    
    private enum SerializationKey {
        static let id = "id"
        static let webTitle = "webTitle"
        static let apiUrl = "apiUrl"
    }
    
    let id : String?
    let webTitle : String?
    let apiUrl : String?
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        self.id  = json[SerializationKey.id].string
        self.webTitle  = json[SerializationKey.webTitle].string
        self.apiUrl  = json[SerializationKey.apiUrl].string
    }
}

