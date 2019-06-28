//
//  DataSource.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 27/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Combine
import Foundation

typealias DataTuple = ([Picture], [Album], [User])

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
}

// MARK: - Private functions
// TODO: have a single function to get a publisher for a specific type
// to avoid copy/past of guard let url... return RESTClient.getData for each entity

extension DataSource {
    
    private func getAlbums() -> AnyPublisher<[Album], Never> {
        guard let url = getUrl(forEntity: .Album) else {
            return Publishers.Just<[Album]>([]).eraseToAnyPublisher()
        }
        return RESTClient.getData(atURL: url)
            .decode(type: [Album].self, decoder: JSONDecoder())
            .catch { _  in
                Publishers.Just<[Album]>([]).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func getPictures() -> AnyPublisher<[Picture], Never> {
        guard let url = getUrl(forEntity: .Picture) else {
            return Publishers.Just<[Picture]>([]).eraseToAnyPublisher()
        }
        return RESTClient.getData(atURL: url)
            .decode(type: [Picture].self, decoder: JSONDecoder())
            .catch { _  in
                Publishers.Just<[Picture]>([]).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func getUsers() -> AnyPublisher<[User], Never> {
        guard let url = getUrl(forEntity: .User) else {
            return Publishers.Just<[User]>([]).eraseToAnyPublisher()
        }
        return RESTClient.getData(atURL: url)
            .decode(type: [User].self, decoder: JSONDecoder())
            .catch { _  in
                Publishers.Just<[User]>([]).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func getUrl(forEntity entity: Entity) -> URL? {
        let urlString = baseURLString + entity.endPoint
        return URL(string: urlString)
    }
}
