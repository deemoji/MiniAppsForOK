//
//  MiniApp.swift
//  MiniAppsForOK
//
//  Created by Дмитрий Мартьянов on 04.09.2024.
//

import UIKit

import WeatherMiniApp
import TickTackToeMiniApp
import TodoMiniApp

enum MiniApp {
    case weather(Int, UIColor)
    case ticTacToe(Int, UIColor)
    case todo(Int, UIColor)
    
}

extension MiniApp: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .weather(let id, _), .ticTacToe(let id, _), .todo(let id, _):
            hasher.combine(id)
        }
    }
}

extension MiniApp {
    var previewViewController: UIViewController {
        switch self {
        case .weather(_, let color):
            return WeatherPreviewViewController(color)
        case .ticTacToe(_, let color):
            return TickTackToePreviewViewController(color)
        case .todo(_, let color):
            return TodoPreviewViewController(color)
        }
    }
    
    var mainViewController: UIViewController {
        switch self {
        case .weather(_, let color):
            return WeatherViewController(color)
        case .ticTacToe(_, let color):
            return TickTackToeViewController(color)
        case .todo(let id, let color):
            return TodoViewController(id: id, color)
        }
    }
}
