//
//  Core.swift
//  AIMLParser
//
//  Created by 张 家豪 on 2018/5/7.
//  Copyright © 2018年 张 家豪. All rights reserved.
//

import Foundation

/**
 核心处理类，持有各个处理模块的实例
 用于管理所有处理模块，并对各模块进行配置
 */
public class Core {
    /// 谓词表
    var predicateMaster: PredicateMaster!
    /// pattern字典树
    var graphMaster = GraphMaster()
    /// aiml处理器
    public var aimlProcessor: AIMLProcessor!
    /// 上次匹配结果
    var lastMatch: Match?
    
    /**
     AIMLProcessor会用到的静态数据集
     用户可自定制
     格式为：["元素名称": 数据]
     */
    public var processorData = [String: Any]()
    
    /// 当没有匹配结果时，将该模版内容当作匹配结果进行处理
    public var noAnswerTemplate = "<random><li>i cant understand what you say</li><li>i cant think</li></random>"
    
    /**
     通过用户自定的AIMLProcessor集合、该集合的域名称以及谓词表的路径实例化核心类
     */
    public init(processors: [String: String]?, processorClassDomain: String?, predicateFileURL: String) {
        aimlProcessor = AIMLProcessor.init(newDelegates: processors, classDomain: processorClassDomain)
        predicateMaster = PredicateMaster(fileURL: predicateFileURL)
        predicateMaster.loadFromFile()
    }
    
    /**
     给定集合名称及集合文件所在路径
     手动配置set，以便处理aiml pattern中的<set>元素
     */
    public func addToSet(name: String, fileURL: String) {
        guard let nsarray = NSArray.init(contentsOfFile: fileURL) else {
            print("set file load error")
            return
        }
        graphMaster.addToSet(name: name, strs: nsarray.toArray())
    }
    
    /**
     让parser解析aiml数据，并将解析完成的内容加入到pattern字典树中
     */
    public func learn(data: Data) {
        let parser = XMLParser(data: data)
        let aimlParser = AIMLParser()
        parser.delegate = aimlParser
        aimlParser.graph = graphMaster
        parser.parse()
    }
    
    /**
     从csv的一行进行学习
     csv一行：<意图位>,<pattern>,<that>,<topic>,<template>,<注释位>
     其中0表示空字符串
     注意每个部分都不应加英文","，否则会导致系统出错
     */
    public func learn(csv: String) {
        let strs = csv.split(separator: ",")
        var tag = 0
        var intent = ""
        var pattern = ""
        var that = ""
        var topic = ""
        var template = ""
        for str in strs {
            let _str = String(str)
            switch tag {
            case 0:
                intent = _str
            case 1:
                pattern = _str
            case 2:
                that = _str
            case 3:
                topic = _str
            case 4:
                template = _str
            default:
                break
            }
            tag += 1
        }
        intent = intent == "0" ? "" : intent
        pattern = pattern == "0" ? "" : pattern
        that = that == "0" ? "" : that
        topic = topic == "0" ? "" : topic
        template = template == "0" ? "" : template
        graphMaster.addCategory(pattern: pattern, that: that, topic: topic, template: template, intent: intent)
    }
    
    /**
     用户输入、上句话内容、主题及意图，获取机器人的回答结果
     */
    public func getResponse(input: String, that: String, topic: String, intent: String? = nil) -> String {
        // 首先匹配
        guard let matchResult = graphMaster.match(input: input, that: that, topic: topic, intent: intent) else {
            // 匹配不到时，返回指定模版
            return aimlProcessor.process(xml: noAnswerTemplate, core: self)
        }
        lastMatch = matchResult
        let template = matchResult.getTemplate()
        
        // 返回匹配到模版的处理结果
        return StringKit.fixRespnoseChinese(aimlProcessor.process(xml: template, core: self))
    }
}

