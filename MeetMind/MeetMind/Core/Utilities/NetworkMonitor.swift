//
//  NetworkMonitor.swift
//  MeetMind
//
//  Created by Sonam Omar on 06/08/26.
//

import Foundation
import Network

/// Observable network connectivity monitor with simulated offline mode support.
@Observable
public final class NetworkMonitor: @unchecked Sendable {
    public static let shared = NetworkMonitor()
    
    public private(set) var isConnected: Bool = true
    public var isSimulatedOffline: Bool = false {
        didSet {
            AppLogger.info("Network simulated offline state changed: \(isSimulatedOffline)", category: AppLogger.network)
        }
    }
    
    public var isEffectiveConnected: Bool {
        isConnected && !isSimulatedOffline
    }
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    public init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
