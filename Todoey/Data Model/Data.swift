//
//  Data.swift
//  Todoey
//
//  Created by Mert İdacı on 5.08.2018.
//  Copyright © 2018 navyblue. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object{
    
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 23
    
}
