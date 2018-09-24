//
//  Notice.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 21/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwiftyJSON

class Notice {
    
    private struct SerializationKeys {
        static let response = "response"
        static let content = "content"
        static let fields = "fields"
        
        static let id = "id"
        static let webTitle = "webTitle"
        static let webPublicationDate = "webPublicationDate"
        static let thumbnail = "thumbnail"
        static let bodyText = "bodyText"
        static let sectionName = "sectionName"
    }

    let webTitle: String?
    let webPublicationDate: String?
    let sectionName: String?
    let thumbnail: String?
    let bodyText: String?
    
    public convenience init(object: Any){
        self.init(json: JSON(object))
    }
    public required init(json: JSON){
        
        let content = json[SerializationKeys.response][SerializationKeys.content]
        let fields = content[SerializationKeys.fields]
        
        self.webTitle = content[SerializationKeys.webTitle].string
        self.webPublicationDate = content[SerializationKeys.webPublicationDate].string
        self.sectionName = content[SerializationKeys.sectionName].string
        self.thumbnail = fields[SerializationKeys.thumbnail].string
        self.bodyText = fields[SerializationKeys.bodyText].string
    }
}
