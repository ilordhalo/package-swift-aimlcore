//
//  StarProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/8.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    默认<star index="1">，index指第index个通配符
    通配符："*","<set>setname</set>","_"
*/
class StarProcessor: NSObject, TemplateProcessor {
    
    func process(str: String, core: Core, attribute: [String: String]) -> String {
        guard let match = core.lastMatch else {
            return ""
        }
        let count = match.inputStars.count
        if count == 0 {
            return ""
        }
        guard let index = attribute["index"], let i = Int(index) else {
            return match.inputStars[count - 1]
        }
        return match.inputStars[count - i]
    }
}
