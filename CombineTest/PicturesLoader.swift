//
//  PicturesLoader.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 20/11/21.
//  Copyright © 2021 Gualtiero Frigerio. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 15.0.0, *)
class PicturesLoader {
    typealias Element = PictureWithImage
    
    init(withPictures pictures: [PictureWithImage]) {
        self.pictures = pictures
    }
    
    func getPicturesStream() -> AsyncStream<PictureWithImage> {
        AsyncStream { continuation in
            Task {
                for picture in pictures {
                    if let url = URL(string: picture.imageUrl),
                       let data = await RESTClient.getData(atURL: url),
                       let image = UIImage(data: data) {
                        var pictureToReturn = picture
                        pictureToReturn.image = image
                        continuation.yield(pictureToReturn)
                    }
                }
                continuation.finish()
            }
        }
    }
    
    // MARK: - Private
    
    private var pictures: [PictureWithImage] = []
    
    private func getNextPicture() async -> PictureWithImage? {
        guard let nextPicture = pictures.popLast(),
              let url = URL(string: nextPicture.imageUrl) else { return nil }
        if let data = await RESTClient.getData(atURL: url) {
            let image = UIImage(data: data)
            var picture = nextPicture
            picture.image = image
            return picture
        }
        return nil
    }
}

@available(iOS 15.0.0, *)
extension PicturesLoader: AsyncSequence, AsyncIteratorProtocol {
    func next() async throws -> Element? {
        await getNextPicture()
    }
    
    func makeAsyncIterator() -> PicturesLoader {
        self
    }
}
