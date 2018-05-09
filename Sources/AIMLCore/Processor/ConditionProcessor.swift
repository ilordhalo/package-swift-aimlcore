//
//  ConditionProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/8.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

class ConditionProcessor: NSObject, TemplateProcessor {
    var parser: XMLParser!
    private let tag = "li"
    private var startTag = false
    var lis = [String]()
    var lias = [(String, String)]()
    private var litext = ""
    
    func process(str: String, core: Core, attribute: [String: String]) -> String {
        parser = XMLParser(data: XMLKit.appendXMLTag(xml: str).data(using: .utf8)!)
        parser.delegate = self
        parser.parse()
        
        for (index, (value0, value1)) in lias.enumerated() {
            if core.predicateMaster.predicate(key: value0) == value1 {
                return core.aimlProcessor.process(xml: lis[index], core: core)
            }
        }
        return ""
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if startTag {
            litext += fixStartElement(element: elementName, attributeDict: attributeDict)
        }
        if elementName == tag {
            startTag = true
            guard let key = attributeDict["name"], let value = attributeDict["value"] else {
                lias.append(("", ""))
                return
            }
            lias.append((key, value))
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if startTag {
            litext += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == tag {
            startTag = false
            lis.append(litext)
            litext = ""
        }
        else if startTag {
            litext += fixEndElement(element: elementName)
        }
    }
}
