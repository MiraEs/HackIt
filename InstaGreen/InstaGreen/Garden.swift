//
//  Garden.swift
//  InstaGreen
//
//  Created by Ilmira Estil on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Garden {
    let address: String
    let boro: String
    let name: String
    let neighborhood: String
    
    init(address: String, boro: String, name: String, neighborhood: String) {
        self.address = address
        self.boro = boro
        self.name = name
        self.neighborhood = neighborhood
    }
    
    convenience init?(from dict: [String: String]) {
        let address = dict["address"]
        let boro = dict["boro"]
        let name = dict["garden_name"]
        let neighborhood = dict["address"]
    }
}
