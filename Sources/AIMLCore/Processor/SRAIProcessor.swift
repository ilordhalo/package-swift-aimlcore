//
//  SRAIProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/7.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

class SRAIProcessor: NSObject, TemplateProcessor {
    var str = ""
    
    func process(str: String, core: Core, attribute: [String: String]) -> String {
        let text = core.aimlProcessor.process(xml: str, core: core)
        return core.getResponse(input: text, that: "", topic: "")
    }
}
