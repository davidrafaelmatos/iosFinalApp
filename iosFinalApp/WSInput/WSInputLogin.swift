//
//  WSInputLogin.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/11/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct WSInputLogin: Encodable, Decodable {
    let username: String
    let password: String
}
