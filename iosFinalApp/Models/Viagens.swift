//
//  Viagens.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct Viagens : Decodable, Encodable{
    let origemNome: String
    let origemCoord: String
    let destinoNome: String
    let destinoCoord: String
    let fkCar: Int
    let fkUser: Int
    let numLugaresDisponiveis: Int
    let estado: Int
}
