//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Paulina on 20.04.2017.
//  Copyright © 2017 Paulina. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
