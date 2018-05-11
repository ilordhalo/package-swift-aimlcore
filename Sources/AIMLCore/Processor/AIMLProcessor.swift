//
//  AIMLProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/6.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    AIML处理器类
    对于不同的aiml元素有不同的处理方法
    该类自带aiml的部分元素处理类
    用户还可以自定aiml元素的处理类，并添加进来
*/
public class AIMLProcessor {
    /// [elementName: className]
    private var delegates: [String: String]
    
    /**
        给定用户自定义的元素名：类名的字典，及类所属域，实例化AIMLProcessor
        如果用户自定义的元素名与该类默认自带的重复，则用用户自定的新内容替换
    */
    init(newDelegates: [String: String]?, classDomain: String?) {
        delegates = ["random": "RandomProcessor", "srai": "SRAIProcessor", "star": "StarProcessor", "set": "SetProcessor", "get": "GetProcessor", "condition": "ConditionProcessor", "think": "ThinkProcessor", "thatstar": "ThatstarProcessor", "map": "MapProcessor"]
        let selfDomain = NSStringFromClass(RandomProcessor.self).domain()
        for key in delegates.keys {
            delegates[key] = selfDomain + delegates[key]!
        }
        
        guard var newD = newDelegates, let domain = classDomain else {
            return
        }
        for key in newD.keys {
            newD[key] = domain + newD[key]!
        }
        delegates += newD
    }
    
    /**
        处理aiml内容
    */
    public func process(xml: String, core: Core) -> String {
        guard let data = XMLKit.appendXMLTag(xml: xml).data(using: .utf8) else {
            fatalError("xml cant convert to data")
        }
        // 解释aiml内容
        let templateParser = TemplateParser(data: data)
        let count = templateParser.firstElementNames.count
        var response = ""
        
        // 对于每个并列的元素都进行相应处理
        for i in 0..<count {
            let elementName = templateParser.firstElementNames[i]
            guard let className = delegates[elementName] else {
                print("element name not found")
                return ""
            }
            guard let processor = Factory.instance(className) as? TemplateProcessor else {
                print("get instance error")
                return ""
            }
            
            response += templateParser.texts[i] + processor.process(str: templateParser.firstElementTexts[i], core: core, attribute: templateParser.firstElementAttributeDicts[i])
        }
        let last = templateParser.texts.last == nil ? "" : templateParser.texts.last!
        return response + last
    }
}
