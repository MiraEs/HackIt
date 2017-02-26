//
//  Garden.swift
//  InstaGreen
//
//  Created by Ilmira Estil on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Gardens {
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
    
    convenience init?(from dict: [String: Any]) {
        let address = dict["address"] as? String ?? ""
        let boro = dict["boro"] as? String ?? ""
        let name = dict["garden_name"] as? String ?? ""
        let neighborhood = dict["address"] as? String ?? ""
        
        self.init(address: address, boro: boro, name: name, neighborhood:neighborhood)
    }
    
    static func getGardens(from arr: [[String:Any]]) -> [Gardens] {
        var allGardens = [Gardens]()
        for garden in arr {
            if let thisGarden = Gardens(from: garden) {
                allGardens.append(thisGarden)
            }
        }
        return allGardens
    }
}
