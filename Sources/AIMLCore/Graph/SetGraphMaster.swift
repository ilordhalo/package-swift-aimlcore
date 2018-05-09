//
//  SetGraphMaster.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/8.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    存储集合的字典树
*/
class SetGraphMaster {
    private var roots = [String: Nodemapper]()
    
    /**
        name：集合名称
        strs：集合内的全部元素
    */
    func add(name: String, strs: [String]) {
        for str in strs {
            add(name: name, str: str)
        }
    }
    
    func add(name: String, str: String) {
        if roots[name] == nil {
            roots[name] = GraphMaster.createNodemapperInstance()
        }
        
        add(parent: &roots[name]!, words: StringKit.wordSplit(str: str))
    }
    
    private func add(parent: inout Nodemapper, words: [String]) {
        if words.count == 0 {
            return
        }
        let head = words[0]
        var tail = words
        tail.removeFirst()
        
        var node: Nodemapper
        if parent.contains(key: head) {
            node = parent[head] as! Nodemapper
        }
        else {
            node = GraphMaster.createNodemapperInstance()
            parent[head] = node
            node.parent = parent
        }
        add(parent: &node, words: tail)
    }
    
    /**
        返回值说明：
        第一个布尔值表示是否匹配前缀
        第二个布尔值表示是否完全匹配
     */
    func match(name: String, str: String) -> (Bool, Bool) {
        if roots[name] == nil {
            return (false, false)
        }
        return match(parent: roots[name]!, words: StringKit.wordSplit(str: str))
    }
    
    private func match(parent: Nodemapper, words: [String]) -> (Bool, Bool) {
        if words.count == 0 {
            if parent.size == 0 {
                // 叶子结点
                return (true, true)
            }
            // 未到达叶子结点
            return (true, false)
        }
        let head = words[0]
        var tail = words
        tail.removeFirst()
        
        if parent.contains(key: head) {
            return match(parent: parent[head] as! Nodemapper, words: tail)
        }
        return (false, false)
    }
}
