//
//  Nodemapper.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/2.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    字典树中的结点需要遵循的协议
*/
protocol Nodemapper {
    subscript(key: Dictionary<String, Any>.Key) -> Any? {get set}
    func remove(value: Any)
    var keys: Dictionary<String, Any>.Keys {get}
    func contains(key: Dictionary<String, Any>.Key) -> Bool
    var size: Int {get}
    var parent: Nodemapper? {get set}
    func height() -> Int
    mutating func setTop()
    var averageSize: Double {get}
    func equal(_ nodemapper: Nodemapper?) -> Bool
    func allSetNames() -> [String]
}
