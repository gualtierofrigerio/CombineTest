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
        guard let pictures = try? await getPictures(),
              let albums = try? await getAlbums(),
              let users = try? await getUsers() else {
                  return nil
              }
        let mergedAlbums = DataSource.mergeAlbums(albums, withPictures: pictures)
        return DataSource.mergeUsers(users, withAlbums: mergedAlbums)
    }
    
    func getUsersWithMergedDataParallel() async -> [User]? {
        async let pictures = getPictures()
        async let albums = getAlbums()
        async let users = getUsers()
        
        do {
            let mergedAlbums = try await DataSource.mergeAlbums(albums, withPictures: pictures)
            return try await DataSource.mergeUsers(users, withAlbums: mergedAlbums)
        }
        catch DataSourceError.conversionError {
            print("error while converting data")
        }
        catch DataSourceError.urlError {
            print("malformed url")
        }
        catch (let error) {
            print("generic error \(error.localizedDescription)")
        }
        return nil
    }
    
    // MARK: - Private
    
    private func getEntity(_ entity:Entity) async throws -> Data? {
        guard let url = getUrl(forEntity: entity) else {
            throw DataSourceError.urlError
        }
        return await RESTClient.getData(atURL: url)
    }
    
    private func getAlbums() async throws -> [Album]  {
        guard let albumsData = try? await getEntity(.Album),
              let albums = try? JSONDecoder().decode([Album].self, from: albumsData) else {
                  throw DataSourceError.conversionError
        }
        return albums
    }
    
    private func getPictures() async throws -> [Picture] {
        guard let picturesData = try? await getEntity(.Picture),
              let pictures = try? JSONDecoder().decode([Picture].self, from: picturesData) else {
                  throw DataSourceError.conversionError
              }
        return pictures
    }
    
    private func getUsers() async throws -> [User] {
        guard let usersData = try? await getEntity(.User),
              let users = try? JSONDecoder().decode([User].self, from: usersData) else {
                  throw DataSourceError.conversionError
            }
        return users
    }
    
    private func getUrl(forEntity entity: Entity) -> URL? {
        let urlString = baseURLString + entity.endPoint
        return URL(string: urlString)
    }
}
