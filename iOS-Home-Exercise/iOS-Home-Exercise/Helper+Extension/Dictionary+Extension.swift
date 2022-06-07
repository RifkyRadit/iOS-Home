//
//  Dictionary+Extension.swift
//  iOS-Home-Exercise
//
//  Created by Administrator on 06/06/22.
//

import Foundation

extension Dictionary {
    var convertQueryString: String {
        let urlParams = self.compactMap ({ (key, value) -> String in
            return "\(key)=\(value)"
        }).sorted().joined(separator: "&")
        return "?\(urlParams)"
    }
}
