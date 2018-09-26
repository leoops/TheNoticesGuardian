//
//  Api.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 19/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiService {
    typealias JsonNoticeHandler = ((Notice?) -> ())
    typealias JsonNoticesHandler = ((Notices?) -> ())
    typealias JsonSearchNoticesHandler = ((SearchNotice?) -> ())
    typealias JsonSectionHandler = (([SectionResults]?) -> ())
    
    static func requestAllSections(showElements: String, handler: JsonSectionHandler?){
        guard let url = URL(string:LinkManager.listOfSections(showElements: showElements)) else {
            return
        }
        Alamofire.request(url).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let value):
                let dataSections = Section(object: value)
                if let handlerUnwrapped = handler {
                    handlerUnwrapped(dataSections.results)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    static func requestNotices(inPage page: Int, withSection section: String, handler: JsonNoticesHandler?){
        guard let url = URL(string: LinkManager.listOfNotices(section: section, pageNumber: "\(page)")) else {
            return
        }
        Alamofire.request(url).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let value):
                let dataNotices = Notices(object: value)
                if let handlerUnwrapped = handler {
                    handlerUnwrapped(dataNotices)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func requestOfSearchNotice(withQueryParam param: String, andPage page: Int, inSection section: String, handler: JsonSearchNoticesHandler?) {
        guard let url = URL(string: LinkManager.listsOfSearchNotices(withQueryParam: param, andPage: "\(page)", inSection: FormatData().AddingPercentEncoding(value: section))) else {
            return
        }
        Alamofire.request(url).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let value):
                let dataSearchNotice = SearchNotice(object: value)
                if let handlerUnwrapped = handler {
                    handlerUnwrapped(dataSearchNotice)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func requestNotice(withId id: String, handler: JsonNoticeHandler?) {
        guard let url = URL(string: LinkManager.itemNotice(id: id)) else {
            return
        }
        Alamofire.request(url).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let value):
                let dataNotice = Notice(object: value)
                if let handlerUnwrapped = handler {
                    handlerUnwrapped(dataNotice)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
}
