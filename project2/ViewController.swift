//
//  ViewController.swift
//  project2
//
//  Created by Ivan Pavic on 21.12.21..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    
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
        
        var alertTitle: String
        var alertTitle2: String
        
        if sender.tag == correctAnswer {
            score += 1
           alertTitle = "Correct"
        } else {
            alertTitle = "Wrong, thats a flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        if questionsAsked == 10 {
            
            alertTitle2 = "Congratulations, you answered 10 questions!"
            
            let qa = UIAlertController(title: alertTitle2, message: "Final score is \(score)", preferredStyle: .alert)
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
}

