//
//  Entities.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 27/06/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Foundation

struct Album:Codable {
    var id:Int
    var title:String
    var userId:Int
    
    var pictures:[Picture]?
    
    mutating func addPicture(_ picture:Picture) {
        if pictures == nil {
            pictures = [Picture]()
        }
        pictures?.append(picture)
    }
}

struct Picture:Codable {
    var id:Int
    var albumId:Int
    var title:String
    var url:String
    var thumbnailUrl:String
}

struct User:Codable {
    var id:Int
    var email:String
    var name:String
    var username:String
    
    var albums:[Album]?
    
    mutating func addAlbum(_ album:Album) {
        if albums == nil {
            albums = [Album]()
        }
        albums?.append(album)
    }
}

enum Entity {
    case Album
    case Picture
    case User
    
    var endPoint: String {
        switch self {
        case .Album:
            return "/albums"
        case .Picture:
            return "/photos"
        case .User:
            return "/users"
        }
    }
}
