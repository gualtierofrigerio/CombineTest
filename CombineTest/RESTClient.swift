//
//  RESTClient.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 27/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Combine
import Foundation

enum RESTClientError : Error {
    case error(String)
}

/// Simple REST client using combine to return a Future
class RESTClient {
    class func getData(atURL url:URL) -> Future<Data, RESTClientError> {
        let session = URLSession.shared
        return Future { promise in
            let task = session.dataTask(with: url) { data, response, error in
                if let err = error {
                    promise(.failure(RESTClientError.error(err.localizedDescription)))
                }
                else {
                    if let data = data {
                        promise(.success(data))
                    }
                    else {
                        let unknownError = RESTClientError.error("Unknown error")
                        promise(.failure(unknownError))
                    }
                }
            }
            task.resume()
        }
    }
}
