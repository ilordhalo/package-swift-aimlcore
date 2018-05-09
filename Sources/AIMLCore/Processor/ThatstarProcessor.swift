//
//  ThatstarProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/8.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

class ThatstarProcessor: NSObject, TemplateProcessor {
    
    func process(str: String, core: Core, attribute: [String : String]) -> String {
        guard let match = core.lastMatch else {
            return ""
        }
        let count = match.thatStars.count
        if count == 0 {
            return ""
        }
        guard let index = attribute["index"], let i = Int(index) else {
            return match.thatStars[count - 1]
        }
        return match.thatStars[count - i]
    }
    
}
