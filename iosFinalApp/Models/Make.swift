//
//  Make.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct Make : Decodable, Encodable{
    let MakeId: Int
    let MakeName: String
    let VehicleTypeId: Int
    let VehicleTypeName: String
}
