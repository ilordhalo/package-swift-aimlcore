//
//  PredicateMaster.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/7.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
    谓词表管理类
    谓词表在本项目中指一些用户的个人信息字典，如：["name": "alice", "age": "27"]
    该字典的以plist的形式在本地存储
    负责建立本地文件、读取本地文件、写入本地文件
*/
class PredicateMaster {
    /// 谓词表
    private var predicateDict = [String: String]()
    /// 本地文件路径
    private var fileURL = ""
    
    init(fileURL: String) {
        self.fileURL = fileURL
    }
    
    func loadFromFile() {
        guard let nsdict = NSDictionary.init(contentsOfFile: fileURL) else {
            // 文件不存在、新建文件
            _ = FileUtil.createFile(fileURL: fileURL)
            let dict = NSDictionary()
            //_ = try? dict.write(to: URL(fileURLWithPath: fileURL))
            dict.write(toFile: fileURL, atomically: true)
            return
        }
        predicateDict = nsdict.toDictionary()
    }
    
    func writeToFile() {
        let nsdict = predicateDict.toNSDictionary()
        //_ = try? nsdict.write(to: URL(fileURLWithPath: fileURL))
        nsdict.write(toFile: fileURL, atomically: true)
    }
    
    func setPredicate(key: String, value: String) {
        predicateDict[key] = value
        writeToFile()
    }
    
    func predicate(key: String) -> String {
        guard let value = predicateDict[key] else {
            return ""
        }
        return value
    }
}

