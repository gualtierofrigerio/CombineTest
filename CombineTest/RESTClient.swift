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
    
    @available (iOS 15.0, *)
    class func getData(atURL url: URL) async -> Data? {
        let request = URLRequest(url: url)
        guard let data = try? await URLSession.shared.data(for: request,
                                                           delegate: nil)  else {
            return nil
        }
        return data.0
    }
    
    // just a couple of example of using AsyncSequence with for loop and iterator
    
    @available (iOS 15.0, *)
    class func getDataIterator(atURL url: URL) async -> Data? {
        let request = URLRequest(url: url)
        var data: Data? = nil
        do {
            let (bytes, _) = try await URLSession.shared.bytes(for: request, delegate: nil)
            data = Data()
            var iterator = bytes.makeAsyncIterator()
            while let nextByte = try await iterator.next() {
                data?.append(nextByte)
            }
        }
        catch (let error) {
            print("error while getting data \(error.localizedDescription)")
        }
        
        return data
    }
    
    @available (iOS 15.0, *)
    class func getDataStream(atURL url: URL) async -> Data? {
        let request = URLRequest(url: url)
        var data: Data? = nil
        do {
            let (bytes, _) = try await URLSession.shared.bytes(for: request, delegate: nil)
            data = Data()
            for try await b in bytes {
                data?.append(b)
            }
        }
        catch (let error) {
            print("error while getting data \(error.localizedDescription)")
        }
        
        return data
    }
    
    class func getDataCompletion(atURL url: URL,
                                 completion: @escaping ((Data?) -> ())) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data)
        }
        task.resume()
    }
}
