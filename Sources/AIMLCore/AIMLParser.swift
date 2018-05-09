//
//  AIMLParser.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/4/16.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    AIML解释器类
    只负责解释<that><topic><aiml><pattern><template>几个元素，解释完毕后将他们加入到pattern字典树中
*/
class AIMLParser: NSObject, XMLParserDelegate {
    
    private enum ParserState: String {
        case in_template = "template"
        case in_pattern = "pattern"
        case in_that = "that"
        case in_topic = "topic"
        case other
    }
    
    private var state = ParserState.other
    weak var graph: GraphMaster?
    var pattern = ""
    var that = ""
    var topic = ""
    var template = ""
    var intent: String?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // 提取<aiml>元素中的属性intent
        if elementName == "aiml" {
            intent = attributeDict["intent"]
        }
        let str = fixStartElement(element: elementName, attributeDict: attributeDict)
        
        // 根据当前解释器状态，将相应解释结果加入到对应元素内容中
        switch state {
        case .in_pattern:
            pattern += str
        case .in_that:
            that += str
        case .in_topic:
            topic += str
        case .in_template:
            template += str
        default:
            break
        }
        
        // 根据新元素名修改解释器状态，解释器是否进入到下一个aiml标签
        switch elementName {
        case ParserState.in_pattern.rawValue:
            state = .in_pattern
        case ParserState.in_that.rawValue:
            state = .in_that
        case ParserState.in_topic.rawValue:
            state = .in_topic
        case ParserState.in_template.rawValue:
            state = .in_template
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch state {
        case .in_pattern:
            pattern += string
        case .in_that:
            that += string
        case .in_topic:
            topic += string
        case .in_template:
            template += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName {
        case ParserState.in_pattern.rawValue:
            state = .other
        case ParserState.in_that.rawValue:
            state = .other
        case ParserState.in_topic.rawValue:
            state = .other
        case ParserState.in_template.rawValue:
            state = .other
        default:
            break
        }
        
        // 当前category匹配完成，开始匹配新的category
        if elementName == StaticString.category {
            addCategoryToGraph()
            pattern = ""
            that = ""
            topic = ""
            template = ""
            return
        }
        
        let str = fixEndElement(element: elementName)
        switch state {
        case .in_pattern:
            pattern += str
        case .in_that:
            that += str
        case .in_topic:
            topic += str
        case .in_template:
            template += str
        default:
            break
        }
    }
    
    /**
        将当前的解释结果加入到pattern字典树中
    */
    private func addCategoryToGraph() {
        guard let graph = graph else {
            fatalError("graph is nil")
        }
        let _pattern = pattern == "" ? nil : pattern
        let _that = that == "" ? nil : that
        let _topic = topic == "" ? nil : topic

        graph.addCategory(pattern: _pattern, that: _that, topic: _topic, template: template, intent: intent)
    }
}
