//
//  NetworkMonitorView.swift
//  NetworkMonitor
//
//  Created by dev dfcc on 2023/05/08.
//

import UIKit

enum NetworkStatusMessage {
    case satisfied
    case notSatisfied
    
    var statusMessage: String {
        switch self {
        case .satisfied:
            return "네트워크에 연결되었습니다."
        case .notSatisfied:
            return "네트워크에 연결되어 있지 않습니다."
        }
    }
}



final class NetworkMonitorView: UIView {
    private let statueLabel = UILabel()
    
    var states: NetworkStatusMessage = .satisfied {
        didSet {
            statueLabel.text = states.statusMessage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(statueLabel)
        statueLabel.translatesAutoresizingMaskIntoConstraints = false
        statueLabel.backgroundColor = .clear
        statueLabel.textColor = .black
        statueLabel.font = .boldSystemFont(ofSize: 20)
        statueLabel.numberOfLines = 2
        
        NSLayoutConstraint
            .activate([
                statueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                statueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
