//
//  ShipViewModel.swift
//  MobileTest
//
//  Created by xieshengyang on 2025/10/26.
//

import Foundation
import Combine

class ShipViewModel {
    @Published var shipDetail: ShipDetail?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    /// combine生命周期管理
    private var cancellables = Set<AnyCancellable>()
    
    func loadData() {
        isLoading = true
        error = nil
        
        ShipDataService.shared.getShipData { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let shipDetail):
                // 当赋值时会触发响应
                self.shipDetail = shipDetail
            case .failure(let error):
                // 当赋值时会触发响应
                self.error = error
            }
        }
    }
}

