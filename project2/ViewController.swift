//
//  ViewController.swift
//  project2
//
//  Created by Ivan Pavic on 21.12.21..
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    var highScoreArray = [Int]()
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem:.add, target: self, action: #selector(displayScore))
        
        let defaults = UserDefaults.standard
        if let savedScores = defaults.object(forKey: "highScore") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                highScoreArray = try jsonDecoder.decode([Int].self, from: savedScores)
            } catch {
                print("Unable to load highscores.")
            }
        }
        setHighScore()
        registerLocal()
        scheduleLocal()
       
    }
    func askQuestion(action:UIAlertAction!) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "SELECT FLAG OF \(countries[correctAnswer].uppercased())"
        questionsAsked += 1
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let button = sender
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3, options: []) {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            button.transform = .identity
        } completion: { finished in
        }

        
        var alertTitle: String
        var alertTitle2: String
        var message: String
        
        if sender.tag == correctAnswer {
            score += 1
            alertTitle = "Correct"
        } else {
            alertTitle = "Wrong, thats a flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        if questionsAsked == 10 {
            alertTitle2 = "Congratulations, you answered 10 questions!"
            message = "Final score: \(score)"
            if score > highScore {
                message = "Way to go! New high score: \(score)"
                highScore = score
                highScoreArray.append(highScore)
                save()
             }
            
            let qa = UIAlertController(title: alertTitle2, message: message, preferredStyle: .alert)
            qa.addAction(UIAlertAction(title: "End", style: .destructive, handler: askQuestion))
            present(qa, animated: true)
            score = 0
            questionsAsked = 0
             
         } else {
             let ac = UIAlertController(title: alertTitle, message: "Your score is \(score).", preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
             present(ac, animated: true)
         }
        setScoreLabel()

    }
    
    @IBOutlet var showScore: UILabel!
    func setScoreLabel() {
        if let label = showScore {
        label.text = "Score: \(score)"
        }
    }
    
    @objc func displayScore () {
        let bi = UIAlertController(title: "Score", message: "Your score is: \(score)", preferredStyle:.alert)
        bi.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present (bi, animated: true)
    }
    
    func save() {
        let jsonEnecoder = JSONEncoder()
        if let savedScores = try? jsonEnecoder.encode(highScoreArray) {
            let defaults = UserDefaults.standard
            defaults.set(savedScores, forKey: "highScore")
        } else {
            print ("Unable to save highscore")
        }
    }
    
    func setHighScore() {
        guard let newHigh = highScoreArray.max() else { return }
        highScore = newHigh
    }
    
    func registerLocal () {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if granted {
                print("Request allowed.")
            } else {
                print("Request denied.")
            }
        }
    }
    
    func scheduleLocal () {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.body = "Daily reminder to play GuessTheFlag."
        content.title = "GuessTheFlag"
        content.sound = .default
        content.categoryIdentifier = "reminder"
        content.userInfo = ["currentHighScore": highScore]
        
        var dateCompoments = DateComponents()
        for i in 1...7 {
            dateCompoments.weekday = i
            dateCompoments.hour = 18
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompoments, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let play = UNNotificationAction(identifier: "play", title: "Play now", options: .foreground)
        let category = UNNotificationCategory(identifier: "reminder", actions: [play], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let currentHighScore = userInfo["currentHighScore"] as? Int {
            if response.actionIdentifier == "play" {
                let ac = UIAlertController(title: "Try to beat!", message: "Current Highscore: \(currentHighScore)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                present(ac, animated: true)
                center.removePendingNotificationRequests(withIdentifiers: ["reminder"])
            }
        }
        completionHandler()
    }
}

