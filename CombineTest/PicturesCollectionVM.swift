//
//  PicturesCollectionVM.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 20/11/21.
//  Copyright © 2021 Gualtiero Frigerio. All rights reserved.
//

import Foundation

class PicturesCollectionVM {
    weak var viewController: PicturesCollectionVC?
    
    var pictures: [PictureWithImage] {
        get {
            loadedPictures
        }
    }
    
    @available(iOS 15.0.0, *)
    func loadPictures(_ pictures: [Picture]) {
        let picturesWithImages: [PictureWithImage]  = pictures.map { PictureWithImage(title: $0.title, imageUrl: $0.url) }
        let pictureLoader = PicturesLoader(withPictures: picturesWithImages)
        Task {
            do {
                for try await picture in pictureLoader {
                    loadedPictures.append(picture)
                    await viewController?.collectionView.reloadData()
                }
            }
            catch {
                print("error while iterating on images")
            }
        }
    }
    
    @available(iOS 15.0.0, *)
    func loadPicturesStream(_ pictures: [Picture]) {
        let picturesWithImages: [PictureWithImage]  = pictures.map {
            PictureWithImage(title: $0.title, imageUrl: $0.url)
        }
        let picturesLoader = PicturesLoader(withPictures: picturesWithImages)
        let stream = picturesLoader.getPicturesStream()
        Task {
            for await picture in stream {
                loadedPictures.append(picture)
                await viewController?.collectionView.reloadData()
            }
        }
    }
    
    private var loadedPictures: [PictureWithImage] = []
}
