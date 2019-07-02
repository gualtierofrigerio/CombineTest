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
            return value.filter({
                $0.filterField.lowercased().contains(self.filter.lowercased())
            })
        }
        return value
    }
    
    var value:[T]
    
    init(initialFilter:String) {
        self.value = [] as! [T]
        self.filter = initialFilter
    }
}
