//
//  MapProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/9.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

class MapProcessor: NSObject, TemplateProcessor {
    
    func process(str: String, core: Core, attribute: [String : String]) -> String {
        let text = core.aimlProcessor.process(xml: str, core: core)
        guard let name = attribute["name"], let map = core.processorData["map"] as? [String: Any], let dict = map[name] as? [String: String], let value = dict[text] else {
            return ""
        }
        return value
    }
    
}
