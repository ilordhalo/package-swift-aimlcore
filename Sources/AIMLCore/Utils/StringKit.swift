//
//  StringKit.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/2.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

public class StringKit {
    /**
        先除去字符串前后的多余空格和换行后将字符串根据空格进行分割
    */
    public static func wordSplit(str: String) -> [String] {
        var trimmedStr = str.trimmingCharacters(in: .whitespacesAndNewlines)
        if StringKit.containChinese(str) {
            trimmedStr = StringKit.fixChineseSentence(trimmedStr)
        }
        return trimmedStr.split(separator: " ").map({
            value in
            return String(value)
        })
    }
}
