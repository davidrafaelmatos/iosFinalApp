//
//  User.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/11/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct User: Encodable, Decodable {
    let idUser: Int
    let username: String
    let password: String
    let nome: String
    let estado: Int
}
