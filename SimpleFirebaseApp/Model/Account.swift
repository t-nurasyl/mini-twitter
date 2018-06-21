//
//  Account.swift
//  SimpleFirebaseApp
//
//  Created by Нурасыл on 10.04.2018.
//  Copyright © 2018 SDU. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Account{
    var name : String?
    var surname : String?
    var birthday : Int?
    
    init(_ name:String?, _ surname:String?, _ birthday:Int?) {
        self.name = name
        self.surname = surname
        self.birthday = birthday
    }
    init(snapshot: FIRDataSnapshot) {
        let profile = snapshot.value as! NSDictionary
        name = profile.value(forKey: "name") as? String
        surname = profile.value(forKey: "surname") as? String
        birthday = profile.value(forKey: "birthday") as? Int
    }
    
    var Name : String?{
        get{
            return name
        }
    }
    var Surname : String?{
        get{
            return surname
        }
    }
    var Birthday : Int?{
        get{
            return birthday
        }
    }
    
    
}
