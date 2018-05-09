//
//  SetProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/8.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

class SetProcessor: NSObject, TemplateProcessor {
    
    func process(str: String, core: Core, attribute: [String : String]) -> String {
        guard let key = attribute["name"] else {
            return ""
        }
        let text = core.aimlProcessor.process(xml: str, core: core)
        core.predicateMaster.setPredicate(key: key, value: text)
        return text
    }
    
}
