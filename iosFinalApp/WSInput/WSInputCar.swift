//
//  WSInputCar.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/12/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import Foundation

struct WSInputCar: Encodable, Decodable {
    let marca: String
    let modelo: String
    let combustivel: Int // é um int
    let consumo: Double // é um double
    let fkUser: Int // é um int
    let estado: Int // é um int
}
