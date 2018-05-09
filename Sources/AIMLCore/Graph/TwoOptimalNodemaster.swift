//
//  TwoOptimalNodemaster.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/2.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    两个预定值位置的树结点实现类
    当结点中存储的内容<=2时，该结构效率远高于一般的字典，当>2时该结构转变为字典
*/
class TwoOptimalNodemaster: Nodemaster {
    
    func equal(_ nodemapper: Nodemapper?) -> Bool {
        guard let node = nodemapper as? TwoOptimalNodemaster else {
            return false
        }
        return Unmanaged.passUnretained(self).toOpaque() == Unmanaged.passUnretained(node).toOpaque()
    }
    
    var size: Int = 0
    
    var key_0: String?
    var key_1: String?
    
    var value_0: Any?
    var value_1: Any?
    
    var parent: Nodemapper?
    
    var height: Int! = 1000000
    
    var hidden: [String : Any]!
    
    var keys: Dictionary<String, Any>.Keys {
        if size < 3 {
            var result = [String: Any]()
            if key_0 != nil {
                result[key_0!] = value_0
            }
            if key_1 != nil {
                result[key_1!] = value_1
            }
            return result.keys
        }
        return hidden.keys
    }
    
    var averageSize: Double {
        var total: Double = 0
        if size < 3 {
            if let value0 = value_0 as? Nodemapper {
                total += value0.averageSize
            }
            if let value1 = value_1 as? Nodemapper {
                total += value1.averageSize
            }
        }
        else {
            for value in hidden.values {
                if let nodemapper = value as? Nodemapper {
                    total += nodemapper.averageSize
                }
            }
        }
        if parent != nil {
            return (Double(size) + (total / Double(size))) / 2.0
        }
        return total / Double(size)
    }
    
    required init() {
    }
    
    subscript(key: String) -> Any? {
        get {
            if size == 0 {
                return nil
            }
            else if size == 1 || size == 2 {
                if key_0 == key {
                    return value_0
                }
                if key_1 == key {
                    return value_1
                }
                return nil
            }
            else {
                return hidden[key]
            }
        }
        set {
            if size < 2 {
                if size == 0 {
                    key_0 = key
                    value_0 = newValue
                    size = 1
                }
                key_1 = key
                value_1 = newValue
                size = 2
            }
            else if size == 2 {
                hidden = [String: Any]()
                hidden[key_0!] = value_0
                hidden[key_1!] = value_1
                key_0 = nil
                key_1 = nil
                value_0 = nil
                value_1 = nil
                size = 3
                return hidden[key] = newValue
            }
            else {
                size += 1
                return hidden[key] = newValue
            }
        }
    }
    
    func remove(value: Any) {
        print("fuck remove")
    }
    
    func contains(key: String) -> Bool {
        if size == 0 {
            return false
        }
        else if size == 1 || size == 2 {
            return key == key_0 || key == key_1
        }
        return hidden.keys.contains(key)
    }
    
    func allSetNames() -> [String] {
        var response = [String]()
        if size == 0 {
            return response
        }
        else if size == 1 || size == 2 {
            guard let name_0 = key_0?.setName() else {
                return response
            }
            response.append(name_0)
            guard let name_1 = key_1?.setName() else {
                return response
            }
            response.append(name_1)
            return response
        }
        else {
            for key in hidden.keys {
                guard let name = key.setName() else {
                    continue
                }
                response.append(name)
            }
            return response
        }
    }
}
