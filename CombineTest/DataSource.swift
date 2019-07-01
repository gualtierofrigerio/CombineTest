//
//  DataSource.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 27/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Combine
import Foundation

enum DataSourceError:Error {
    case error(String)
}

class DataSource {
    
    var baseURLString:String
    
    init(baseURL:String) {
        self.baseURLString = baseURL
    }
    
    func getUsersWithMergedData() -> AnyPublisher<[User], Never> {
        return Publishers.Zip3(getPictures(), getAlbums(), getUsers())
            .map {
                let mergedAlbums = DataSource.mergeAlbums($1, withPictures: $0)
                return DataSource.mergeUsers($2, withAlbums: mergedAlbums)
            }
            .eraseToAnyPublisher()
    }
    
    // alternative with CombineLatest
    func getUsersWithMergedDataLatest() -> AnyPublisher<[User], Never> {
        return Publishers.CombineLatest3(getPictures(), getAlbums(), getUsers()) {pictures ,albums, users in
            let mergedAlbums = DataSource.mergeAlbums(albums, withPictures: pictures)
            let mergedUsers = DataSource.mergeUsers(users, withAlbums: mergedAlbums)
            return mergedUsers
            }.eraseToAnyPublisher()
    }
}

// MARK: - Class functions

extension DataSource {
    
    class func mergeAlbums(_ albums:[Album], withPictures pictures:[Picture]) -> [Album] {
        var albumsWithPictures = [Album]()
        for var album in albums {
            for picture in pictures {
                if picture.albumId == album.id {
                    album.addPicture(picture)
                }
            }
            albumsWithPictures.append(album)
        }
        return albumsWithPictures
    }
    
    class func mergeUsers(_ users:[User], withAlbums albums:[Album]) -> [User] {
        var usersWithAlbums = [User]()
        for var user in users {
            for album in albums {
                if album.userId == user.id {
                    user.addAlbum(album)
                }
            }
            usersWithAlbums.append(user)
        }
        return usersWithAlbums
    }
    
    class func makeError(withString errorString:String) -> DataSourceError {
        print("make error...")
        return DataSourceError.error(errorString)
    }
}

// MARK: - Private functions

extension DataSource {
    
    private func getEmptyData() -> Data {
        return Data()
    }
    
    private func getEntity(_ entity:Entity) -> AnyPublisher<Data, DataSourceError> {
        guard let url = getUrl(forEntity: entity) else {
            return Publishers.Fail(error:DataSource.makeError(withString: "cannot get url")).eraseToAnyPublisher()
        }
        return RESTClient.getData(atURL: url)
            .replaceError(with: getEmptyData())
            .catch { _ in
                Publishers.Fail(error:DataSource.makeError(withString: "error converting data")).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func getAlbums() -> AnyPublisher<[Album], Never> {
        return getEntity(.Album)
            .decode(type: [Album].self, decoder: JSONDecoder())
            .catch { error in
                Publishers.Just<[Album]>([])
            }
            .eraseToAnyPublisher()
    }
    
    private func getPictures() -> AnyPublisher<[Picture], Never> {
        return getEntity(.Picture)
            .decode(type: [Picture].self, decoder: JSONDecoder())
            .catch { error in
                Publishers.Just<[Picture]>([])
            }
            .eraseToAnyPublisher()
    }
    
    private func getUsers() -> AnyPublisher<[User], Never> {
        return getEntity(.User)
            .decode(type: [User].self, decoder: JSONDecoder())
            .catch { error in
                Publishers.Just<[User]>([])
            }
            .eraseToAnyPublisher()
    }
    
    private func getUrl(forEntity entity: Entity) -> URL? {
        let urlString = baseURLString + entity.endPoint
        return URL(string: urlString)
    }
}
