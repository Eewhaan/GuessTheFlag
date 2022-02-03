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
        //1: dodajem imena drzava(zastava) u countries array
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        //3: dodajem border i bojim border oko buttona
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
        // projekat 3: dodajem i dugme na ciji klik dobijam alert o scoreu
        navigationItem.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem:.add, target: self, action: #selector(displayScore))
       
    }
//11: posto smo u handler upisali askQuestion moramo da dodelimo parametar methodu
    func askQuestion(action:UIAlertAction!) {
        // 4: sad hocu da mi zastave uvek budu drugacije
        countries.shuffle()
        //5: nasumicno generisem ime drzave cija se zastava trazi
        correctAnswer = Int.random(in: 0...2)
        
        //2: pravim funkciju koja dodeljuje neke zastave u buttone kada se pozove
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        //6: dodajem ime trazene drzave u naslov + bonus: dodajem i trenutni score
        title = "SELECT FLAG OF \(countries[correctAnswer].uppercased())"
        //bonu: prebrojavam koliko je puta funkcija pozvana
        questionsAsked += 1
    }
    //7: dodajem action na pritisak dugmeta, sva tri buttona povezujem sa ovom funkcijom i dodeljujem im tagove u main
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var alertTitle: String
        var alertTitle2: String
        //8: u zavisnosti od toga da li je tacan odgovor dobijamo razlicit rezultat i poruku
       if sender.tag == correctAnswer {
            score += 1
           alertTitle = "Correct"
        } else {
            alertTitle = "Wrong, thats a flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        //bonus: dodajem jos jedan alert ako je igrac odgovorio na 10 pitanja i prekidam igru
         if questionsAsked == 10 {
             alertTitle2 = "Congratulations, you answered 10 questions!"
             
         let qa = UIAlertController(title: alertTitle2, message: "Final score is \(score)", preferredStyle: .alert)
         qa.addAction(UIAlertAction(title: "End", style: .destructive, handler: askQuestion))
         present(qa, animated: true)
         score = 0
        questionsAsked = 0
         } else {
        //9: ovde ubacujemo Alert prilikom klika na dugme
        let ac = UIAlertController(title: alertTitle, message: "Your score is \(score).", preferredStyle: .alert)
        //10: Alert-u dodajemo dugme; handler zahteva da mu se doda closure, ukoliko ukucamo askQuestion() kazemo mu da uradi method i onda ce onda dati closure, a kad napisemo askQuestion onda mu kazemo da pokrene askQuestion() method!!
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
         }
        setScoreLabel()

    }
// bonus: dodao sam Label u kom se ispisuje trenutni score igraca
    @IBOutlet var showScore: UILabel!
    func setScoreLabel() {
        if let label = showScore {
        label.text = "Score: \(score)"
        }
    }
    //projekat 3: metod koji pozivam pri kliku na dugme
    @objc func displayScore () {
        
        let bi = UIAlertController(title: "Score", message: "Your score is: \(score)", preferredStyle:.alert)
        bi.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present (bi, animated: true)
        
    }
}

