//
//  PicturesCollectionVC.swift
//  CombineTest
//
//  Created by Gualtiero Frigerio on 20/11/21.
//  Copyright © 2021 Gualtiero Frigerio. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PictureCell"

class PictureCell: UICollectionViewCell {
    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var pictureLabel: UILabel!
}

class PicturesCollectionVC: UICollectionViewController {
    var viewModel: PicturesCollectionVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.pictures.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureCell,
           let picture = viewModel?.pictures[indexPath.row] {
            cell.pictureLabel.text = picture.title
            cell.pictureImageView.image = picture.image
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

}
