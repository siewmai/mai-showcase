//
//  DataService.swift
//  mai-showcase
//
//  Created by Siew Mai Chan on 15/11/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://mai-showcase.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}
