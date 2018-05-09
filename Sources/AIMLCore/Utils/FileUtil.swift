//
//  FileUtil.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/7.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

public class FileUtil {
    /**
        在指定目录创建文件，如果目录不存在则该方法会先创建目录
    */
    public static func createFile(fileURL: String) -> Bool {
        if !FileManager.default.fileExists(atPath: fileURL) {
            guard (try? FileManager.default.createDirectory(atPath: fileURL.fileDirectory(), withIntermediateDirectories: true, attributes: nil)) != nil else {
                return false
            }
            FileManager.default.createFile(atPath: fileURL, contents: nil, attributes: nil)
        }
        return true
    }
}
