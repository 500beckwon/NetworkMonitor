//
//  NetworkMonitorManager.swift
//  NetworkMonitor
//
//  Created by dev dfcc on 2023/05/08.
//

import UIKit
import Network

final class NetworkMonitorManager {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    private var networkWindow: UIWindow?
    private var networkMonitorView: NetworkMonitorView!
    
    init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
    }
    
    func startMonitoring(handler stateUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            stateUpdateHandler(path.status)
        }
        
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func controlNetworkAccess() {
        startMonitoring { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .satisfied:
                self.removeNetworkWindow()
            case .unsatisfied:
                self.showUnsatisfiedWindow()
            default: break
            }
        }
    }
    
    func showUnsatisfiedWindow() {
        DispatchQueue.main.async {
            guard
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                let windowScene = sceneDelegate.window?.windowScene as? UIWindowScene else { return }
            
            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = .statusBar
            window.makeKeyAndVisible()
            self.networkMonitorView = NetworkMonitorView(frame: window.bounds)
            window.addSubview(self.networkMonitorView)
            self.networkWindow = window
        }
    }
    
    func removeNetworkWindow() {
        guard networkMonitorView != nil else { return }
        DispatchQueue.main.async {
            self.networkMonitorView.states  = .satisfied
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.networkWindow?.resignKey()
            self.networkWindow?.isHidden = true
            self.networkWindow = nil
        }
    }
}
