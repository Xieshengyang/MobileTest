//
//  ShipInfo.swift
//  MobileTest
//
//  Created by xieshengyang on 2025/10/26.
//

import Foundation

struct ShipDetail: Codable {

    let shipReference: String
    let shipToken: String
    let canIssueTicketChecking: Bool
    let expiryTime: String
    let duration: Int
    var segments: [Segment]
}

struct Segment: Codable {
    let id: Int
    let originAndDestinationPair: OriginDestinationPair
}

struct OriginDestinationPair: Codable {
    let destination: LocationInfo
    let destinationCity: String
    let origin: LocationInfo
    let originCity: String
}

struct LocationInfo: Codable {
    let code: String
    let displayName: String
    let url: String
}
