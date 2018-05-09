//
//  DictionaryExtension.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/7.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

public func +=(prefix: inout [String: String], rhs: [String: String]) {
    for key in rhs.keys {
        prefix[key] = rhs[key]!
    }
}

public extension NSDictionary {
    /**
        保证字典中存放的键值对均为String类型
    */
    public func toDictionary() -> Dictionary<String, String> {
        var dict = [String: String]()
        for (key, value) in self {
            dict[key as! String] = (value as! String)
        }
        return dict
    }
}

public extension Dictionary {
    /**
        保证字典中存放的键值对均为String类型
    */
    public func toNSDictionary() -> NSDictionary {
        var values = [Any]()
        var keys = [NSCopying]()
        for value in self.values {
            values.append(value)
        }
        for key in self.keys {
            keys.append(key as! NSCopying)
        }
        return NSDictionary.init(objects: values, forKeys: keys)
    }
    
    /**
        获取字典的复制，只适用于键值对均为String类型的字典
    */
    public func new() -> [String: String] {
        var dict = [String: String]()
        for key in self.keys {
            dict[key as! String] = (self[key] as! String)
        }
        return dict
    }
}
