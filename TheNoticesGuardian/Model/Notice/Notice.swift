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
        // Atributos pai
        static let response = "response"
        
        // Atributos de response
        static let content = "content"
        
        // Atributo de content
        static let id = "id"
        static let webTitle = "webTitle"
        static let webPublicationDate = "webPublicationDate"
        static let sectionName = "sectionName"
        static let fields = "fields"

        // Atributos de fields
        static let bodyText = "bodyText"
        static let thumbnail = "thumbnail"
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
        self.webTitle = content[SerializationKeys.webTitle].string
        self.webPublicationDate = content[SerializationKeys.webPublicationDate].string
        self.sectionName = content[SerializationKeys.sectionName].string
        
        let fields = content[SerializationKeys.fields]
        self.thumbnail = fields[SerializationKeys.thumbnail].string
        self.bodyText = fields[SerializationKeys.bodyText].string
    }
}
