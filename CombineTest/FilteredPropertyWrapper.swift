//
//  FilteredPropertyWrapper.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 02/07/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

@propertyWrapper
struct Filtered<T> where T: Filterable {
    var filter:String
    
    var filtered:[T] {
        if filter.count > 0 {
            return wrappedValue.filter({
                $0.filterField.lowercased().contains(self.filter.lowercased())
            })
        }
        return wrappedValue
    }
    
    var wrappedValue:[T]
    
    init(initialFilter:String) {
        self.wrappedValue = [] as! [T]
        self.filter = initialFilter
    }
}
