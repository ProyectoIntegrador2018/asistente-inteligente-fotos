//
//  Enums.swift
//  AIT
//
//  Created by Luis Rady on 27/10/20.
//

import UIKit

enum Images {
    static let hideGrid = UIImage(named: "hideGrid")
    static let showGrid = UIImage(named: "showGrid")
    static let toLeft = UIImage(named: "toLeft")
    static let toRight = UIImage(named: "toRight")
    static let llantasLayout = UIImage(named: "Llantas layout")
    static let izqChatarraLayout = UIImage(named: "Chatarra layout izq")
    static let derChatarraLayout = UIImage(named: "Chatarra layout der")
}

enum CameraTypes {
    case llanta, chatarra
}

enum ChatarraDirection {
    case toLeft, toRight
}
