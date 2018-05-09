//
//  Nodemaster.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/2.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    字典树中结点的具体实现类要遵循的协议
*/
protocol Nodemaster: Nodemapper {
    var hidden: [String: Any]! {get set}
    var height: Int! {get set}
    init()
}

extension Nodemaster {
    mutating func fillInHeight(height: Int) {
        if self.height > height {
            self.height = height
        }
        guard var parent = self.parent as? Nodemaster else {
            return
        }
        parent.fillInHeight(height: height + 1)
    }
    mutating func setTop() {
        fillInHeight(height: 0)
    }
    func height() -> Int {
        return height
    }
}
