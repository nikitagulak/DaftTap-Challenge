//
//  ViewController.swift
//  DaftTap Challenge
//
//  Created by Nick on 08/05/2019.
//  Copyright © 2019 Nikita Gulak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if items.isEmpty {
            collectionView.isHidden = true
            captionLabel.text = "Play the game and you will see your result here"
            let image = UIImage(named: "Illustration.png")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 118, height: 118)
            imageView.center = self.view.center
            view.addSubview(imageView)
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var captionLabel: UILabel!
    
    let items: [String] = []
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
//        let vc = storyboard!.instantiateViewController(withIdentifier: "gameScreen") as! GameScreenController
//        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as! RecordCell
        cell.tapsLabel.text = items[indexPath.row]
        return cell
    }


}

