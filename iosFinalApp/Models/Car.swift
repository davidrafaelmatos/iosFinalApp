//
//  Car.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct Car : Decodable, Encodable{
    let idCar: String // é um int
    let marca: String
    let modelo: String
    let combustivel: String // é um int
    let consumo: String // é um double
    let fkUser: String // é um int
    let estado: String // é um int
}
