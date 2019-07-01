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

class RESTClient {
    class func getDataPublisher(atURL url:URL) -> AnyPublisher<Data, RESTClientError> {
        let session = URLSession.shared
        return AnyPublisher { subscriber in
            let task = session.dataTask(with: url) { data, response, error in
                if let err = error {
                    subscriber.receive(completion: .failure(RESTClientError.error( err.localizedDescription)))
                }
                else {
                    if let data = data {
                        _ = subscriber.receive(data)
                        subscriber.receive(completion: .finished)
                    }
                    else {
                        let unknownError = RESTClientError.error("Unknown error")
                        subscriber.receive(completion: .failure(unknownError))
                    }
                }
            }
            task.resume()
        }
    }
    
    class func getData(atURL url:URL) -> Publishers.Future<Data, RESTClientError> {
        let session = URLSession.shared
        return Publishers.Future { promise in
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
