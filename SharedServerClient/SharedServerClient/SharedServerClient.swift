//
//  SharedServerClient.swift
//  SharedServerClient
//
//  Created by Roded Zats on 19/03/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Kitura
import KituraHelloWorld

public struct RouterCreator {
    public static func create() -> Router {
        return KituraHelloWorld.RouterCreator.create()
    }
}
