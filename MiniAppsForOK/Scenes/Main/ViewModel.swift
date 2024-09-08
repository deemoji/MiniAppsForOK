//
//  ViewModel.swift
//  MiniAppsForOK
//
//  Created by Дмитрий Мартьянов on 06.09.2024.
//

import Foundation


final class ViewModel {
    
    var appsLoaded: (([MiniApp]) -> Void)? {
        didSet {
            appsLoaded?(apps)
        }
    }
    
    private var apps: [MiniApp] = [.ticTacToe(0, .systemRed), .todo(0, .systemRed), .weather(0, .systemRed), .ticTacToe(1, .systemGreen), .todo(1, .systemGreen), .weather(1, .systemGreen), .ticTacToe(2, .systemBlue), .todo(2, .systemBlue), .weather(2, .systemBlue), .ticTacToe(3, .systemYellow)]
    
    func app(at index: Int) -> MiniApp? {
        guard index >= 0 && index < apps.count else { return nil }
        return apps[index]
    }
}
