//
//  NetworkService.swift
//  MobileTest
//
//  Created by xieshengyang on 2025/10/26.
//

import Foundation

class ShipDataService {
    
    static let shared = ShipDataService()
    private init() {}
    
    // 缓存键
    private let cacheKey = "shipDetail_cache"
    private let cacheTimestampKey = "shipDetail_cache_timestamp"
    
    // 数据有效期（5秒）
    private let dataValidDuration: Int = 5

    // 是否要强制刷新
    var isForceRefresh: Bool {
        if let lastDate = UserDefaults.standard.value(forKey: self.cacheTimestampKey) as? Date {
            let seconds = Int(Date.now.timeIntervalSince(lastDate))
            return seconds >= dataValidDuration
        }
        return true
    }
    
    func getShipData(completion: @escaping (Result<ShipDetail, Error>) -> Void) {
        if isForceRefresh {
            getRemoteData(completion: completion)
        } else {
            getCacheDate(completion: completion)
        }
    }
    // 读取缓存
    private func getCacheDate(completion: @escaping (Result<ShipDetail, Error>) -> Void) {
        LogUtils.log("获取缓存数据")
        if let data = UserDefaults.standard.value(forKey: cacheKey) as? Data {
            do{
                let shipDetail = try JSONDecoder().decode(ShipDetail.self, from: data)
                LogUtils.log("获取缓存数据成功：\(data)")
                completion(.success(shipDetail))
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NSError(
                        domain: "CatchService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "读取缓存失败"]
                    )))
                }
            }
        } else {
            completion(.failure(NSError(
                domain: "CacheService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "读取缓存失败"]
            )))
        }
    }
    
    // 请求网络数据并缓存
    private func getRemoteData(completion: @escaping (Result<ShipDetail, Error>) -> Void) {
        LogUtils.log("获取远程数据")
        DispatchQueue.global().async {
            // 获取文件路径
            guard let filePath = Bundle.main.path(forResource: "booking", ofType: "json") else {
                // 文件不存在的错误回调：切换到主线程
                DispatchQueue.main.async {
                    completion(.failure(NSError(
                        domain: "DateService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "booking.json文件不存在或未添加到项目中"]
                    )))
                }
                return
            }
            // 读取文件内容并解析
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let decoder = JSONDecoder()
                LogUtils.log("远程data: \(data)")
                var shipDetail = try decoder.decode(ShipDetail.self, from: data)
                
                // 如果之前的缓存存在，则将缓存的内容添加到当前的数据
                if let data = UserDefaults.standard.value(forKey: self.cacheKey) as? Data {
                    do {
                        let cacheShipDetail = try JSONDecoder().decode(ShipDetail.self, from: data)
                        shipDetail.segments.append(contentsOf: cacheShipDetail.segments)
                    } catch {
                        
                    }
                }
                
                self.cacheData(shipDetail)
                // 解析成功：切换到主线程回调
                DispatchQueue.main.async {
                    completion(.success(shipDetail))
                }
            } catch {
                // 解析失败（如数据格式错误）：切换到主线程回调
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // 缓存数据
    private func cacheData(_ data: ShipDetail) {
        LogUtils.log("开始缓存")
        do {
            let encodedData = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encodedData, forKey: cacheKey)
            UserDefaults.standard.set(Date.now, forKey: cacheTimestampKey)
            LogUtils.log("缓存成功")
        } catch {
            LogUtils.log("缓存失败: \(error.localizedDescription)")
        }
    }
}
