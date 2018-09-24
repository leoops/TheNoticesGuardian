//
//  Results.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 21/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwiftyJSON



class NoticesResults {
    
    private struct SerializationKeys {
        static let fields = "fields"
        static let id = "id"
        static let webTitle = "webTitle"
        static let webPublicationDate = "webPublicationDate"
        static let thumbnail = "thumbnail"
    }
    
    let webTitle : String?
    let webPublicationDate : String?
    let thumbnail : String?
    let id : String?
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        self.id  = json[SerializationKeys.id].string
        self.webTitle  = json[SerializationKeys.webTitle].string
        self.webPublicationDate  = json[SerializationKeys.webPublicationDate].string
        self.thumbnail  = json[SerializationKeys.fields][SerializationKeys.thumbnail].string
    }
}
