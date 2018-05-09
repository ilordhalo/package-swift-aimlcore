//
//  Match.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/2.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    匹配结果类
*/
class Match {
    /// 存储pattern中的通配符表示的字符串，倒序
    private(set) var inputStars = [String]()
    
    /// 存储that中的通配符表示的字符串，倒序
    private(set) var thatStars = [String]()
    
    /// 存储topic中的通配符表示的字符串，倒序
    private(set) var topicStars = [String]()
    
    var pattern: String!
    var that: String!
    var topic: String!
    var botid: String!
    var nodemapper: Nodemapper!
    
    func pushInputWildcardContent(_ str: String) {
        inputStars.append(str)
    }
    
    func pushThatWildcardContent(_ str: String) {
        thatStars.append(str)
    }
    
    func pushTopicWildcardContent(_ str: String) {
        topicStars.append(str)
    }
    
    func getTemplate() -> String {
        return nodemapper[StaticString.TEMPLATE] as! String
    }
    
    func getFileName() -> String {
        return nodemapper[StaticString.FILENAME] as! String
    }
}
