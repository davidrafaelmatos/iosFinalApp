//
//  WSReturnViagem.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/12/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import Foundation

struct WSReturnViagem: Encodable, Decodable {
    let get:Bool
    let result:[Viagens]
}
