//
//  WSReturnDeleteCar.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/12/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import Foundation

struct WSReturnDeleteCar: Encodable, Decodable {
    let delete: Bool
    let mensagem: String
}
