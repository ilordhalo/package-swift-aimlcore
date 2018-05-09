//
//  XMLKit.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/7.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

public class XMLKit {
    /**
        向xml中加上父标签<xml>，为配合XMLParser处理XML
    */
    public static func appendXMLTag(xml: String) -> String {
        return "<xml>" + xml + "</xml>"
    }
    
    /**
        简单的提取xml中的第一个元素名称
    */
    public static func elementName(xml: String) -> String {
        var start = false
        var response = ""
        let trimmedXml = xml.trimmingCharacters(in: .whitespacesAndNewlines)
        for c in trimmedXml {
            if start && (c == ">" || c == " ") {
                break
            }
            if start {
                if c != "/" {
                    response += String(c)
                }
            }
            if c == "<" {
                start = true
            }
        }
        return response
    }
}
