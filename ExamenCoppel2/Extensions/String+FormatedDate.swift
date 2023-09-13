//
//  String+FormatedDate.swift
//  ExamenCoppel2
//
//  Created by Equipo on 10/09/23.
//

import Foundation

extension String {
    func formatDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let inputDate = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let formattedDateStr = dateFormatter.string(from: inputDate)
            return formattedDateStr
        } else {
            print("Invalid date format")
        }
        return self
    }
}
