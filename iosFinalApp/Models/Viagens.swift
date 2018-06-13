//
//  Viagens.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct Viagens : Decodable, Encodable{
    let idViagem: String
    let origemNome: String
    let origemCoordLat: String
    let origemCoordLong: String
    let destinoNome: String
    let destinoCoordLat: String
    let destinoCoordLong: String
    let fkCar: String // int
    let fkUser: String // int
    let totalKm: String // double
    let estado: String //int
    let quantidadeLugares: String //int
    let lugaresDisponiveis: String //int
    let dataViagem: String
}
