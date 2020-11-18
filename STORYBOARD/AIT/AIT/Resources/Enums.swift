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
    static let izqChatarraLayout = UIImage(named: "layout_izq_der")
    static let derChatarraLayout = UIImage(named: "layout_der_izq")
}

enum CameraTypes {
    case llanta, chatarra
}

enum ChatarraDirection {
    case toLeft, toRight
}
