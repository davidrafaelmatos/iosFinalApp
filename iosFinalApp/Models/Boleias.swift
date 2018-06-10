//
//  Boleias.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct Boleias : Decodable, Encodable{
    let idBoleia: Int
    let fkViagem: Int
    let fkUser: Int
    let estado: Int
    let estadoPagamento: Int
}
