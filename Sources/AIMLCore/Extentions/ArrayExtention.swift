//
//  ArrayExtention.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/8.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

public extension NSArray {
    /**
        保证数组中存放的数据为String，才可以调用该方法
    */
    public func toArray() -> [String] {
        var array = [String]()
        for e in self {
            array.append(e as! String)
        }
        return array
    }
}
