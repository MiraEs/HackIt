//
//  Post.swift
//  InstaGreen
//
//  Created by Ilmira Estil on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Post {
    internal let comment: String
    internal let userId: String
    internal let key: String
    
    init(userId: String, comment: String, key: String) {
        self.comment = comment
        self.userId = userId
        self.key = key
    }
}
