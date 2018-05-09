//
//  StringExtension.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/7.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

public extension String {
    /**
        获取某特定字符串中的域信息
        如：abc.def.xyz 中的abc.def.
    */
    public func domain() -> String {
        var strs = self.split(separator: ".")
        var response = ""
        strs.removeLast()
        for str in strs {
            response += String(str) + "."
        }
        return response
    }
    
    /**
        获取文件路径字符串中的文件目录信息
        如：/abc/def/xyz.plist 中的/abc/def/
    */
    public func fileDirectory() -> String {
        var strs = self.split(separator: "/")
        var response = "/"
        strs.removeLast()
        for str in strs {
            response += String(str) + "/"
        }
        return response
    }
    
    /**
        获取某特定字符串中的集合名称信息
        如："<set>color</set>" 中的color
    */
    public func setName() -> String? {
        if self.contains("<set>") {
            var startTag = false
            var response = ""
            for c in self {
                if startTag {
                    if c == "<" {
                        return response
                    }
                    response += String(c)
                }
                if c == ">" {
                    startTag = true
                }
            }
        }
        return nil
    }
}
