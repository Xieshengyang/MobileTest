//
//  Log.swift
//  MobileTest
//
//  Created by xieshengyang on 2025/10/27.
//

import Foundation

/// 自定义日志工具
enum LogUtils {
    // 静态日期格式化器（避免重复初始化，提高性能）
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS" // 时间格式：年-月-日 时:分:秒.毫秒
        formatter.timeZone = TimeZone.current // 使用当前时区
        return formatter
    }()
    
    /// 自定义日志打印
    /// - Parameters:
    ///   - message: 要打印的内容（支持任意类型）
    ///   - function: 所在函数名（默认自动获取当前函数名）
    static func log<T>(_ message: T, function: String = #function) {
        let currentTime = dateFormatter.string(from: Date()) // 获取当前时间字符串
        // 打印格式：[时间] [函数名] 内容
        print("[ \(currentTime) ] [ \(function) ] \(message)")
    }
}
