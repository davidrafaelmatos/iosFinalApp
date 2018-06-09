//
//  Car.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct Car : Decodable, Encodable{
    let Marca: String
    let Modelo: String
    let TipoCombustivel: Int
    let Comsumos: Double
    let fkUser: Int
    let estado: Int
}
