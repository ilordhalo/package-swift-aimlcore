//
//  GetProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/8.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

class GetProcessor: NSObject, TemplateProcessor {
    
    func process(str: String, core: Core, attribute: [String : String]) -> String {
        guard let key = attribute["name"] else {
            return ""
        }
        return core.predicateMaster.predicate(key: key)
    }
    
}
