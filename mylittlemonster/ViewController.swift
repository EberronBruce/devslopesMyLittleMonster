//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Bruce Burgess on 3/24/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var handImg: DragImg!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var deadLabel: UILabel!
    @IBOutlet weak var restartBtn: UIButton!
    
    @IBOutlet weak var characterSelectView: UIView!
    
    @IBOutlet weak var brakImageView: MonsterImg!
    @IBOutlet weak var bulkImageView: MonsterImg!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    var gameOverState = false
    var characterImageName = "idle"
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        //changeNeed()
        
        setUpSound()
        
        //startGame()
        
        brakImageView.playIdleAnimation("babyidle")
        bulkImageView.playIdleAnimation("idle")
        
        
        
    }
    
    func setUpSound(){
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxDeath.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }

    }
    
    func startGame() {
        monsterImg.playIdleAnimation(characterImageName)
        characterSelectView.hidden = true
        
        deadLabel.hidden = true
        restartBtn.hidden = true
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        handImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        monsterHappy = false
        penalties = 0
        //gameOverState = false
        
        startTimer()

    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        handImg.alpha = DIM_ALPHA
        handImg.userInteractionEnabled = false
        
        if currentItem == 0 || currentItem == 2 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
        
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties += 1
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Img.alpha = OPAQUE
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Img.alpha = OPAQUE
                penalty3Img.alpha = DIM_ALPHA
            } else if penalties >= MAX_PENALTIES {
                penalty3Img.alpha = OPAQUE
            } else {
                penalty1Img.alpha = DIM_ALPHA
                penalty2Img.alpha = DIM_ALPHA
                penalty3Img.alpha = DIM_ALPHA
            }
            
        }
        
        changeNeed()
        
        if penalties >= MAX_PENALTIES {
            gameOver()
        }
        
        monsterHappy = false
        
    }
    
    func changeNeed() {
        let rand = arc4random_uniform(3) //0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            handImg.alpha = DIM_ALPHA
            handImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
            
        } else if rand == 1  {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            handImg.alpha = DIM_ALPHA
            handImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        } else {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            handImg.alpha = OPAQUE
            handImg.userInteractionEnabled = true
        }
        
        currentItem = rand
    }
    
    func gameOver() {
        timer.invalidate()
        if characterImageName == "idle" {
            monsterImg.playDeathAnimation("dead")
        } else {
            monsterImg.playDeathAnimation("babydead")
        }
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        handImg.alpha = DIM_ALPHA
        handImg.userInteractionEnabled = false
        sfxDeath.play()
        
        deadLabel.hidden = false
        restartBtn.hidden = false
        

    }

    @IBAction func restartTapped(sender: AnyObject) {
        restartGame()
    }
    
    func restartGame() {
        foodImg.userInteractionEnabled = true
        heartImg.userInteractionEnabled = true
        handImg.userInteractionEnabled = true
        foodImg.alpha = OPAQUE
        heartImg.alpha = OPAQUE
        handImg.alpha = OPAQUE
        
        
        monsterImg.playIdleAnimation("idle")
        
        deadLabel.hidden = true
        restartBtn.hidden = true
        
        //startGame()
        getSelection()
    
    }
    
    @IBAction func brakTapped(sender: AnyObject) {
        characterImageName = "babyidle"
        backgroundImageView.image = UIImage(named: "bg")
        startGame()

    }
    
    
    @IBAction func bulkTapped(sender: AnyObject) {
        characterImageName = "idle"
        backgroundImageView.image = UIImage(named: "bg2")
        startGame()

    }
    
    func getSelection() {
        characterSelectView.hidden = false
    }

}

