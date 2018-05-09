//
//  RandomProcessor.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/4/18.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

class RandomProcessor: NSObject, TemplateProcessor {
    var parser: XMLParser!
    private let tag = "li"
    private var startTag = false
    var lis = [String]()
    private var litext = ""
    
    func process(str: String, core: Core, attribute: [String: String]) -> String {
        parser = XMLParser(data: XMLKit.appendXMLTag(xml: str).data(using: .utf8)!)
        parser.delegate = self
        parser.parse()
        let count = lis.count
        if count == 0 {
            return ""
        }
        let randint = Int(arc4random()) % count
        return core.aimlProcessor.process(xml: lis[randint], core: core)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if startTag {
            litext += fixStartElement(element: elementName, attributeDict: attributeDict)
        }
        if elementName == tag {
            startTag = true
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
