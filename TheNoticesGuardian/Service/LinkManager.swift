//
//  linkManager.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 20/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation

class LinkManager {

    private struct Path {
        static let file = "Services"
        static let type = "plist"
    }
    private struct Keys {
        static let notices = "notices"
        static let session = "session"
        static let notice = "notice"
        static let search = "search"
    }
    
    private struct Tags{
        //
        static let id = "<id>"
        static let section = "<section>"
        static let page = "<pageNumber>"
        static let showElements = "<showElements>"
        static let queryParam = "<queryParam>"
    }
   
    static func listOfSections(showElements: String) -> String {
        if let contentFile = contentOfFile(path: Path.file, type: Path.type), var link = contentFile[Keys.session] as? String {
            link = link.replacingOccurrences(of: Tags.showElements, with: showElements)
            return link
        }
        return ""
    }
    
    static func listOfNotices(section: String, pageNumber: String) -> String {
        if let contentFile = contentOfFile(path: Path.file, type: Path.type), var link = contentFile[Keys.notices] as? String {
            link = link.replacingOccurrences(of: Tags.section, with: section)
            link = link.replacingOccurrences(of: Tags.page, with: pageNumber)
            return link
        }
        return ""
    }
    static func itemNotice(id: String) -> String {
        let contentFile = contentOfFile(path: Path.file, type: Path.type)
        if var link = contentFile?[Keys.notice] as? String {
            link = link.replacingOccurrences(of: Tags.id, with: id)
            return link
        }
        return ""
    }
    
    static func listsOfSearchNotices(withQueryParam param: String,andPage page: String, inSection section: String) -> String {
        if let contentFile = contentOfFile(path: Path.file, type: Path.type), var link = contentFile[Keys.search] as? String {
            link = link.replacingOccurrences(of: Tags.queryParam, with: param)
            link = link.replacingOccurrences(of: Tags.section, with: section)
            link = link.replacingOccurrences(of: Tags.page, with: page)
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
