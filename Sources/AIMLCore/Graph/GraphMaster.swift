//
//  GraphMaster.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/4/19.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    pattern字典树
    每个结点记录一个单词或一个中文字符
*/
class GraphMaster {
    
    private enum MatchState {
        case IN_INPUT
        case IN_THAT
        case IN_TOPIC
    }
    
    static func createNodemapperInstance() -> Nodemapper {
        return TwoOptimalNodemaster()
    }
    
    private var nodemapperCount = 1
    
    /**
        存储整个森林，每棵树通过intent来唯一标识
        默认用空字符串表示无明确意图，即intent=""
    */
    private var roots = [String: Nodemapper]()
    
    private var sgm = SetGraphMaster()
    
    init() {
    }
    
    func addToSet(name: String, strs: [String]) {
        sgm.add(name: name, strs: strs)
    }
    
    /**
        向树中添加匹配串
    */
    func add(pattern: String, that: String, topic: String, intent: String?) -> Nodemapper {
        let _intent = intent == nil ? "" : intent!
        if roots[_intent] == nil {
            roots[_intent] = GraphMaster.createNodemapperInstance()
        }
        
        var path = StringKit.wordSplit(str: pattern)
        path.append(StaticString.THAT)
        path += StringKit.wordSplit(str: that)
        path.append(StaticString.TOPIC)
        path += StringKit.wordSplit(str: topic)
        var pathIterator = path.makeIterator()
        return add(pathIterator: &pathIterator, parent: &roots[_intent]!)
    }
    
    private func add(pathIterator: inout IndexingIterator<Array<String>>, parent: inout Nodemapper) -> Nodemapper {
        guard let word = pathIterator.next() else {
            parent.setTop()
            return parent
        }
        var node: Nodemapper
        if parent.contains(key: word) {
            node = parent[word] as! Nodemapper
        }
        else {
            node = GraphMaster.createNodemapperInstance()
            nodemapperCount += 1
            parent[word] = node
            node.parent = parent
        }
        return add(pathIterator: &pathIterator, parent: &node)
    }
    
    /**
        根据用户输入在树中查找是否有匹配串
    */
    func match(input: String, that: String, topic: String, intent: String?) -> Match? {
        let _intent = intent == nil ? "" : intent!
        if roots[_intent] == nil {
            return nil
        }
        var inputPath: [String]
        if input.count > 0 {
            inputPath = StringKit.wordSplit(str: input)
        }
        else {
            inputPath = [String]()
            inputPath.append(StaticString.ASTERISK)
        }
        
        inputPath.append(StaticString.THAT)
        // that内容过多时，不考虑that
        if that.count > 0 && that.count < 50 {
            inputPath += StringKit.wordSplit(str: that)
        }
        else {
            inputPath.append(StaticString.ASTERISK)
        }
        
        inputPath.append(StaticString.TOPIC)
        if topic.count > 0 {
            inputPath += StringKit.wordSplit(str: topic)
        }
        else {
            inputPath.append(StaticString.ASTERISK)
        }
        
        let now = Date().timeIntervalSince1970
        let matchResult = match(nodemapper: roots[_intent]!, parent: roots[_intent]!, input: inputPath, wildcardContent: StaticString.EMPTY_STRING, path: StaticString.EMPTY_STRING, matchState: .IN_INPUT, expiration: now)
        return matchResult
    }
    
    /**
        nodemapper：当前结点
        parent：当前结点的父结点
        input：剩余未匹配到的输入
        wildcardContent：通配符匹配到的内容
        path：以匹配的路径
        matchState：当前匹配状态
        expiration：匹配耗时
    */
    private func match(nodemapper: Nodemapper, parent: Nodemapper, input: [String], wildcardContent: String, path: String, matchState: MatchState, expiration: Double) -> Match? {
        let now = Date().timeIntervalSince1970
        // 匹配时间超过一秒，判定为无匹配结果
        if now - expiration > 1 {
            return nil
        }
        
        // 剪枝优化
        if input.count < nodemapper.height() {
            return nil
        }
        
        var matchResult: Match?
        if input.count == 0 {
            if nodemapper.contains(key: StaticString.TEMPLATE) {
                matchResult = Match()
                matchResult!.botid = path
                matchResult!.nodemapper = nodemapper
                return matchResult
            }
            return nil
        }
        
        let head = input[0]
        var tail = input
        tail.removeFirst()
        
        var nextState = matchState
        
        if nodemapper.contains(key: StaticString.UNDERSCORE) {
            var newPath = StaticString.EMPTY_STRING
            if path.count > 0 {
                newPath += path
                newPath += StaticString.SPACE
            }
            newPath += StaticString.UNDERSCORE
            
            matchResult = match(nodemapper: nodemapper[StaticString.UNDERSCORE] as! Nodemapper, parent: nodemapper, input: tail, wildcardContent: head, path: newPath, matchState: nextState, expiration: expiration)
            if matchResult != nil {
                switch nextState {
                case .IN_INPUT:
                    if wildcardContent.count > 0 {
                        matchResult!.pushInputWildcardContent(wildcardContent)
                    }
                case .IN_THAT:
                    if wildcardContent.count > 0 {
                        matchResult!.pushThatWildcardContent(wildcardContent)
                    }
                case .IN_TOPIC:
                    if wildcardContent.count > 0 {
                        matchResult!.pushTopicWildcardContent(wildcardContent)
                    }
                }
                return matchResult
            }
        }
        
        if nodemapper.contains(key: head) {
            if head.starts(with: StaticString.MARKER_START) {
                if head == StaticString.THAT {
                    nextState = .IN_THAT
                }
                else if head == StaticString.TOPIC {
                    nextState = .IN_TOPIC
                }
                matchResult = match(nodemapper: nodemapper[head] as! Nodemapper, parent: nodemapper, input: tail, wildcardContent: StaticString.EMPTY_STRING, path: StaticString.EMPTY_STRING, matchState: nextState, expiration: expiration)
                if matchResult != nil {
                    switch nextState {
                    case .IN_THAT:
                        if wildcardContent.count > 0 {
                            matchResult!.pushInputWildcardContent(wildcardContent)
                            matchResult!.pattern = path
                        }
                    case .IN_TOPIC:
                        if wildcardContent.count > 0 {
                            matchResult!.pushThatWildcardContent(wildcardContent)
                            matchResult!.that = path
                        }
                    case .IN_INPUT:
                        break
                    }
                }
                return matchResult
            }
            else {
                var newPath = StaticString.EMPTY_STRING
                if path.count > 0 {
                    newPath += path
                    newPath += StaticString.SPACE
                }
                newPath += head
                
                matchResult = match(nodemapper: nodemapper[head] as! Nodemapper, parent: nodemapper, input: tail, wildcardContent: wildcardContent, path: newPath, matchState: nextState, expiration: expiration)
                if matchResult != nil {
                    return matchResult
                }
            }
        }
        
        let names = nodemapper.allSetNames()
        let count = input.count
        for name in names {
            var prestr = input[0]
            var result: (Bool, Bool)
            var s = 1
            var newTail = input
            newTail.removeFirst()
            while s < count {
                result = sgm.match(name: name, str: prestr)
                if result == (true, true) {
                    let str = "<set>" + name + "</set>"
                    var newPath = StaticString.EMPTY_STRING
                    if path.count > 0 {
                        newPath += path
                        newPath += StaticString.SPACE
                    }
                    newPath += str
                    matchResult = match(nodemapper: nodemapper[str] as! Nodemapper, parent: nodemapper, input: newTail, wildcardContent: prestr, path: newPath, matchState: nextState, expiration: expiration)
                    
                    if matchResult != nil {
                        switch nextState {
                        case .IN_INPUT:
                            if wildcardContent.count > 0 {
                                matchResult!.pushInputWildcardContent(wildcardContent)
                            }
                        case .IN_THAT:
                            if wildcardContent.count > 0 {
                                matchResult!.pushThatWildcardContent(wildcardContent)
                            }
                        case .IN_TOPIC:
                            if wildcardContent.count > 0 {
                                matchResult!.pushTopicWildcardContent(wildcardContent)
                            }
                        }
                        return matchResult
                    }
                }
                else if result == (true, false) {
                    prestr += " " + input[s]
                }
                else {
                    break
                }
                s += 1
                newTail.removeFirst()
            }
        }
        
        if nodemapper.contains(key: StaticString.ASTERISK) {
            var newPath = StaticString.EMPTY_STRING
            if path.count > 0 {
                newPath += path
                newPath += StaticString.SPACE
            }
            newPath += StaticString.ASTERISK
            
            matchResult = match(nodemapper: nodemapper[StaticString.ASTERISK] as! Nodemapper, parent: nodemapper, input: tail, wildcardContent: head, path: newPath, matchState: nextState, expiration: expiration)
            if matchResult != nil {
                switch nextState {
                case .IN_INPUT:
                    if wildcardContent.count > 0 {
                        matchResult!.pushInputWildcardContent(wildcardContent)
                    }
                case .IN_THAT:
                    if wildcardContent.count > 0 {
                        matchResult!.pushThatWildcardContent(wildcardContent)
                    }
                case .IN_TOPIC:
                    if wildcardContent.count > 0 {
                        matchResult!.pushTopicWildcardContent(wildcardContent)
                    }
                }
                return matchResult
            }
        }
        
        if nodemapper.equal(parent[StaticString.ASTERISK] as? Nodemapper) || nodemapper.equal(parent[StaticString.UNDERSCORE] as? Nodemapper) {
            return match(nodemapper: nodemapper, parent: parent, input: tail, wildcardContent: wildcardContent + StaticString.SPACE + head, path: path, matchState: nextState, expiration: expiration)
        }
        
        return nil
    }
    
    /**
        向树中添加新的category
    */
    func addCategory(pattern: String?, that: String?, topic: String?, template: String, intent: String?) {
        let _pattern = pattern == nil ? StaticString.ASTERISK : pattern!
        let _that = that == nil ? StaticString.ASTERISK : that!
        let _topic = topic == nil ? StaticString.ASTERISK : topic!
        var node = add(pattern: _pattern, that: _that, topic: _topic, intent: intent)
        
        if node[StaticString.TEMPLATE] != nil {
            print("category exist:" + _pattern)
            return
        }
        node[StaticString.TEMPLATE] = template
    }
}
