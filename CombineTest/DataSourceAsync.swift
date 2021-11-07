//
//  DataSourceAsync.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 06/11/21.
//  Copyright © 2021 Gualtiero Frigerio. All rights reserved.
//

import Foundation

@available(iOS 15.0, *)
class DataSourceAsync {
    var baseURLString:String
    
    init(baseURL:String) {
        self.baseURLString = baseURL
    }
    
    func getUsersWithMergedData() async -> [User]? {
        guard let pictures = await getPictures(),
              let albums = await getAlbums(),
              let users = await getUsers() else {
                  return nil
              }
        let mergedAlbums = DataSource.mergeAlbums(albums, withPictures: pictures)
        return DataSource.mergeUsers(users, withAlbums: mergedAlbums)
    }
    
    // MARK: - Private
    
    private func getEntity(_ entity:Entity) async throws -> Data? {
        guard let url = getUrl(forEntity: entity) else {
            return nil
        }
        return await RESTClient.getData(atURL: url)
    }
    
    private func getAlbums() async -> [Album]?  {
        guard let albumsData = try? await getEntity(.Album),
              let albums = try? JSONDecoder().decode([Album].self, from: albumsData) else {
            return nil
        }
        return albums
    }
    
    private func getPictures() async -> [Picture]? {
        guard let picturesData = try? await getEntity(.Picture),
              let pictures = try? JSONDecoder().decode([Picture].self, from: picturesData) else {
                  return nil
              }
        return pictures
    }
    
    private func getUsers() async -> [User]? {
        guard let usersData = try? await getEntity(.User),
              let users = try? JSONDecoder().decode([User].self, from: usersData) else {
                return nil
            }
        return users
    }
    
    private func getUrl(forEntity entity: Entity) -> URL? {
        let urlString = baseURLString + entity.endPoint
        return URL(string: urlString)
    }
}
