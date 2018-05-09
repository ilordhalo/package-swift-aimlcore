//
//  TemplateParser.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/8.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    解释aiml中的template元素中的内容
    初始化完成后，通过firstElementNames、firstElementTexts、firstElementAttributeDicts、texts获取解释结果
*/
class TemplateParser: NSObject, XMLParserDelegate {
    private var parser: XMLParser
    
    /// 标记是否在平行元素内部
    private var startTag = false
    
    /**
        下面四个数组记录最外层平行的几个元素的信息
        最外层平行元素形如："<xml><star><random><li>hi, <star/></li><random></xml>"
        中的<star> <random>
        <xml>元素在本项目中当作无用元素，直接无视。
    */
    /// 存储元素的名称
    private(set) var firstElementNames = [String]()
    
    /**
        存储元素内的文本
        如："<xml><srai>test1</srai>test2<star/>test3</xml>"
        中的test1
    */
    private(set) var firstElementTexts = [String]()
    
    /// 存储元素的属性
    private(set) var firstElementAttributeDicts = [[String: String]]()
    
    /**
        存储元素中间文本
        如："<xml>test1<star/>test2<srai>test3</srai>test4</xml>"
        中的test1 test2 test4
        该数组的长度保证是上面数组长度+1
    */
    private(set) var texts = [String]()
    
    private var firstElementName = ""
    private var firstElementText = ""
    private var firstElementAttributeDict = [String: String]()
    private var text = ""
    
    init(data: Data) {
        parser = XMLParser(data: data)
        super.init()
        
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // xml为临时添加的无用标签
        if elementName == "xml" {
            return
        }
        
        if startTag {
            firstElementText += fixStartElement(element: elementName, attributeDict: attributeDict)
            return
        }
        startTag = true
        firstElementName = elementName
        firstElementAttributeDict = attributeDict
        texts.append(text)
        text = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if startTag {
            firstElementText += string
        }
        else {
            text += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "xml" {
            texts.append(text)
            return
        }
        if elementName != firstElementName {
            firstElementText += fixEndElement(element: elementName)
        }
        else {
            startTag = false
            firstElementNames.append(firstElementName)
            firstElementTexts.append(firstElementText)
            firstElementAttributeDicts.append(firstElementAttributeDict.new())
            firstElementName = ""
            firstElementText = ""
            firstElementAttributeDict = [String: String]()
        }
    }
}
