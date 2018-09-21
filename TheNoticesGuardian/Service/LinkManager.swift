//
//  linkManager.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 20/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation

class LinkManager {

    static let pathFile = "Services"
    static let pathType = "plist"
    
    private struct Keys {
        static let notices = "notices"
        static let session = "session"
        static let apiKey = "apiKey"
        static let url = "url"
        static let notice = "notice"
        static let search = "search"
    }
    
    private struct Tags{
        static let page = "<pageNumber>"
        static let apiKey = "<apiKey>"
        static let url = "<url>"
        static let session = "<session>"
        static let showFields = "<showFields>"
        static let showElements = "<showElements>"
        static let id = "<id>"
    }
   
    static func listOsSessions(showElements: String) -> String {
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var link = contentFile?[Keys.session] as? String {
            link = link.replacingOccurrences(of: Tags.showElements, with: showElements)
            return link
        }
        return ""
    }
    
    static func listOfNotices(session: String, pageNumber: String) -> String {
        if let contentFile = contentOfFile(path: pathFile, type: pathType), var link = contentFile[Keys.notices] as? String {
            link = link.replacingOccurrences(of: Tags.session, with: session)
            link = link.replacingOccurrences(of: Tags.page, with: pageNumber)
            return link
        }
        return ""
    }
    
    static func listOfSearchNotices() -> String {
        return ""
    }
    
    static func itemNotice(id: String) -> String {
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var link = contentFile?[Keys.notice] as? String {
            link = link.replacingOccurrences(of: Tags.id, with: id)
            return link
        }
        return ""
    }
    
    static func contentOfFile(path: String, type: String) -> Dictionary<String,AnyObject>? {
        if let path = Bundle.main.path(forResource: path, ofType: type) {
            if let dictionary = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject> {
                return dictionary
            }
            
        }
        return nil
    }
}
