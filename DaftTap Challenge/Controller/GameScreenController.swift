//
//  GameScreenController.swift
//  DaftTap Challenge
//
//  Created by Nick on 08/05/2019.
//  Copyright © 2019 Nikita Gulak. All rights reserved.
//

import UIKit
import CoreData

class GameScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isTopElementsHidden(true)
        
        countDownLabelSetUp()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    var timer = Timer()
    var countDownTimeInSeconds = 3
    var gameTimeInSeconds = 5
    
    var countDownLabel = UILabel()
    
    var tapRecognizer = UITapGestureRecognizer()
    var numberOfTaps = 0
    
    @IBOutlet weak var numberOfTapsLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeBar: UIView!
    
    func startGame() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimeRemain), userInfo: nil, repeats: true)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func countDownLabelSetUp() {
        countDownLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        countDownLabel.center = self.view.center
        countDownLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        countDownLabel.font = UIFont.boldSystemFont(ofSize: 50.0)
        countDownLabel.textAlignment = .center
        countDownLabel.text = String(countDownTimeInSeconds)
        self.view.addSubview(countDownLabel)
    }
    
    func isTopElementsHidden(_ bool: Bool) {
        numberOfTapsLabel.isHidden = bool
        remainingTimeLabel.isHidden = bool
        remainingTimeBar.isHidden = bool
    }
    
    func saveResult(numberOfTaps: Int, date: Date) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "BestResult", in: context)
        let newResult = NSManagedObject(entity: entity!, insertInto: context)
        newResult.setValue(numberOfTaps, forKey: "numberOfTaps")
        newResult.setValue(date, forKey: "timeStamp")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func deleteLowestResult() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BestResult")
        request.returnsObjectsAsFaults = false
        do {
            let records = try context.fetch(request)
//            let objectToDelete = records.min { a, b in (a as! BestResultRecord).numberOfTaps < (b as! BestResultRecord).numberOfTaps} as! [NSManagedObject]
            let objectToDelete = records.min { a, b in (a as AnyObject).numberOfTaps < (b as AnyObject).numberOfTaps} as! NSManagedObject
            context.delete(objectToDelete)
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    @objc func countDown() {
        countDownTimeInSeconds -= 1
        
        countDownLabel.text = String(countDownTimeInSeconds)
        
        if countDownTimeInSeconds == 0 {
            timer.invalidate()
            countDownLabel.isHidden = true
            isTopElementsHidden(false)
            startGame()
        }
    }
    
    @objc func gameTimeRemain() {
        gameTimeInSeconds -= 1
        
        remainingTimeLabel.text = "\(gameTimeInSeconds) seconds"
        
        if gameTimeInSeconds == 0 {
            timer.invalidate()
            tapRecognizer.isEnabled = false
            
            let date = Date()
            var titleForAlert = "You've tapped \(numberOfTaps) times"
            
            if bestResultRecords.isEmpty {
                saveResult(numberOfTaps: numberOfTaps, date: date)
            } else if bestResultRecords.count < 5 {
                for record in bestResultRecords {
                    if record.numberOfTaps != numberOfTaps {
                        saveResult(numberOfTaps: numberOfTaps, date: date)
                    }
                }
            } else {
                if numberOfTaps > bestResultRecords.min(by: { (BestResultRecord1, BestResultRecord2) -> Bool in
                    return BestResultRecord1.numberOfTaps < BestResultRecord2.numberOfTaps ? true : false
                })!.numberOfTaps {
                    saveResult(numberOfTaps: numberOfTaps, date: date)
                    deleteLowestResult()
                }
            }
            
            let alert = UIAlertController(title: "Result", message: "You've tapped \(numberOfTaps) times", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: { (action) in
                self.dismiss(animated: false, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func viewTapped() {
        numberOfTaps += 1
        numberOfTapsLabel.text = "\(numberOfTaps) taps"
    }

}

extension Date {
    func localString(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium) -> String {
        return DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
    }
}
