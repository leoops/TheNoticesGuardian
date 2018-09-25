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
        static let notice = "notice"
        static let notices = "notices"
        static let search = "search"
        static let searchWithSection = "searchWithSection"
        static let session = "session"
    }
    
    private struct Tags{
        //
        static let id = "<id>"
        static let page = "<pageNumber>"
        static let queryParam = "<queryParam>"
        static let section = "<section>"
        static let showElements = "<showElements>"
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
        if let contentFile = contentOfFile(path: Path.file, type: Path.type), var link = contentFile[Keys.notice] as? String {
            link = link.replacingOccurrences(of: Tags.id, with: id)
            return link
        }
        return ""
    }
    
    static func listsOfSearchNotices(withQueryParam param: String,andPage page: String, inSection section: String) -> String {
        
        if let contentFile = contentOfFile(path: Path.file, type: Path.type),
            var link = section == "" ? contentFile[Keys.search] as? String : contentFile[Keys.searchWithSection] as? String {
            if section != ""
            {
                link = link.replacingOccurrences(of: Tags.section, with: section)
            }
            link = link.replacingOccurrences(of: Tags.queryParam, with: param)
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
