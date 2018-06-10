//
//  Proposta.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/10/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct Propossta : Decodable, Encodable{
    let fkBoleia: Int
    let fkUser: Int
    let estado: Int //0 para pendente, 1 para aceite, 2 para recusado
}
