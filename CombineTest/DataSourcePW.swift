//
//  DataSourcePW.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 01/07/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Combine

/// Alternative implementation of the DataSource class using property wrappers
/// Some of the logic is moved to RemoteEntity so this class only has to
/// combine the 3 publishers and return the merged users
class DataSourcePW {
    @RemoteEntity(entity:.Album) var albums:[Album]
    @RemoteEntity(entity:.Picture) var pictures:[Picture]
    @RemoteEntity(entity:.User) var users:[User]
    
    func getUsersWithMergedData() -> AnyPublisher<[User], Never> {
        return Publishers.Zip3(_pictures.publisher, _albums.publisher, _users.publisher)
            .map {
                let mergedAlbums = DataSourcePW.mergeAlbums($1, withPictures: $0)
                return DataSourcePW.mergeUsers($2, withAlbums: mergedAlbums)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Class functions
    
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
