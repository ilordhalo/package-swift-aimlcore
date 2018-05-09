//
//  XMLParserDelegateExtension.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/7.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

public extension XMLParserDelegate {
    /**
        还原完整的xml头元素内容，如：<aiml name="a">
    */
    public func fixStartElement(element: String, attributeDict: [String: String]) -> String {
        return "<" + element + fixAttribute(attributeDict: attributeDict)
    }
    
    /**
        还原完整的xml尾元素内容，如：</aiml>
    */
    public func fixEndElement(element: String) -> String {
        return "</" + element + ">"
    }
    
    /**
        还原完整的xml头元素中的属性内容
    */
    public func fixAttribute(attributeDict: [String: String]) -> String {
        if attributeDict.keys.count == 0 {
            return ">"
        }
        var result = ""
        for key in attributeDict.keys {
            result += " " + key + "=\"" + attributeDict[key]! + "\""
        }
        return result + ">"
    }
}
