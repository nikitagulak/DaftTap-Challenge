//
//  ViewController.swift
//  DaftTap Challenge
//
//  Created by Nick on 08/05/2019.
//  Copyright © 2019 Nikita Gulak. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBestResults()
        сollectionViewEmptinessChecker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBestResults()
        сollectionViewEmptinessChecker()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    
    // MARK: COLLECTION VIEW METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestResultRecords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordCell", for: indexPath) as! RecordCell
        cell.tapsLabel.text = "\(bestResultRecords[indexPath.row].numberOfTaps) taps"
        cell.timeLabel.text = "\(bestResultRecords[indexPath.row].timeStamp.localString())"
        return cell
    }
    
    
    
    // MARK: GETTING RECORDS FROM COREDATA
    func fetchBestResults() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BestResult")
        request.returnsObjectsAsFaults = false
        var fetchedResult = [BestResultRecord]()
        do {
            let records = try context.fetch(request)
            for data in records as! [NSManagedObject] {
                fetchedResult.append(BestResultRecord(numberOfTaps: data.value(forKey: "numberOfTaps") as! Int, timeStamp: data.value(forKey: "timeStamp") as! Date))
            }
            fetchedResult.sort { (a, b) -> Bool in
                a.numberOfTaps > b.numberOfTaps
            }
            bestResultRecords = fetchedResult
            
        } catch {
            print("Failed fetching CoreData")
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    
    
    // MARK: UI SETTING Methods
    let illustration = UIImageView(image: UIImage(named: "Illustration.png")!)
    
    func сollectionViewEmptinessChecker() {
        if bestResultRecords.isEmpty {
            collectionView.isHidden = true
            captionLabel.text = "Play the game and you will see your result here"
            illustration.frame = CGRect(x: 0, y: 0, width: 118, height: 118)
            illustration.center = self.view.center
            view.addSubview(illustration)
        } else {
            collectionView.isHidden = false
            captionLabel.text = "BEST RESULT"
            illustration.removeFromSuperview()
        }
    }

}

