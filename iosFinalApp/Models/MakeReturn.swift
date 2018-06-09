//
//  MakeReturn.swift
//  iosFinalApp
//
//  Created by DocAdmin on 6/9/18.
//  Copyright © 2018 davidmatos. All rights reserved.
//

import UIKit

struct MakeReturn: Decodable, Encodable{
    let Count: Int
    let Message: String
    let SearchCriteria: String?
    let Results: [Make]
}
