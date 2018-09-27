//
//  Extensions.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 26/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation

extension String{
    
    /// Metodo de converte de caracteres especiais de uma string em alfanumerico
    ///
    /// - Returns: string convertida
    func addingPercentEncoding() -> String {
        if let link = self.addingPercentEncoding(withAllowedCharacters: NSMutableCharacterSet.alphanumeric() as CharacterSet){
            return link
        }
            return self
    }
    
    func formatToDate(format: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        return date
    }
    func formatToStringDate(oldFormat: String, newFormat: String) -> String {
        let date = String().formatToDate(format: oldFormat)
        let newStringDate = date.convertToString(format: newFormat)
        
        return newStringDate
    }
}

extension Date {
    func convertToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let newDate: String = dateFormatter.string(from: self)
        
        return newDate
    }
}
