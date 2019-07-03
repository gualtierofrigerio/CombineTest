//
//  EntitiesPropertyWrapper.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 01/07/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Foundation
import Combine

@propertyWrapper
struct RemoteEntity<T> where T:Decodable {
    let url:URL?
    let baseURLString = "https://jsonplaceholder.typicode.com"
    var defaultValue:T
    var wrappedValue:T
    
    var publisher:AnyPublisher<T, Never> {
        guard let url = url else {
            return Just(self.defaultValue).eraseToAnyPublisher()
        }
        return RESTClient.getData(atURL: url)
            .decode(type: T.self, decoder: JSONDecoder())
            .catch { error in
                Just(self.defaultValue).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    init(entity:Entity) {
        self.defaultValue = [] as! T
        self.url = URL(string:baseURLString + entity.endPoint)
        self.wrappedValue = defaultValue
    }
}
