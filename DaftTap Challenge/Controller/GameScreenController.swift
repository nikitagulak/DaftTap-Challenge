//
//  GameScreenController.swift
//  DaftTap Challenge
//
//  Created by Nick on 08/05/2019.
//  Copyright © 2019 Nikita Gulak. All rights reserved.
//

import UIKit

class GameScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isTopElementsHidden(true)
        
        countDownLabelSetUp()
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    var countDownTimer = Timer()
    var countDownTimeInSeconds = 3
    var countDownLabel = UILabel()
    
    var gameTimer = Timer()
    var gameTimeInSeconds = 5
    
    @IBOutlet weak var numberOfTapsLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeBar: UIView!
    
    @objc func countDown() {
        countDownTimeInSeconds -= 1
        
        countDownLabel.text = String(countDownTimeInSeconds)
        
        if countDownTimeInSeconds == 0 {
            countDownTimer.invalidate()
            
            countDownLabel.isHidden = true
            
            isTopElementsHidden(false)
            
            startGame()
        }
    }
    
    @objc func gameTimeRemain() {
        gameTimeInSeconds -= 1
        
        print("REMAINING TIME: \(gameTimeInSeconds)")
        
        remainingTimeLabel.text = "\(gameTimeInSeconds) seconds"
        
        if gameTimeInSeconds == 0 {
            gameTimer.invalidate()
        }
    }
    
    func startGame() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimeRemain), userInfo: nil, repeats: true)
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

}
