//
//  Proposta.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct Proposta : Decodable, Encodable{
    let fkBoleia: Int
    let fkUser: Int
    let estado: Int //0 para eliminado, 1 para pendente, 2 para aceite, 3 para recusado
}
