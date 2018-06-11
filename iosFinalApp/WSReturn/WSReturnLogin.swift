//
//  WSReturnLogin.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/11/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct WSReturnLogin : Decodable, Encodable{
    let Login: Bool
    let nome: String
    let id: Int
}
