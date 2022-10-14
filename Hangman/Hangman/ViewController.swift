//
//  ViewController.swift
//  Hangman
//
//  Created by Ilona Punya on 11.10.22.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var textField: UITextField!
    var buttonsView: UIView!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map({ String($0) })
    var words = ["bread", "breath", "brick", "bridge", "bright", "broken", "hair", "half", "hall", "hammer", "hand", "happen", "happy", "hard", "hat", "hate", "have", "he", "head", "healthy", "hear", "heavy", "hello", "help", "heart", "heaven", "height", "hen", "her", "here", "hers", "hide", "high", "hill", "him", "his", "hit", "hobby", "hold", "hole", "holiday", "home", "hope", "horse", "hospital", "hot", "hotel", "house", "how", "hundred", "hungry", "hour", "hurry", "husband", "hurt"]
    var choosenWord = ""
    var cryptedWord = "" {
        didSet {
            textField.text = cryptedWord
        }
    }
    var hangPictures = [String]()
    var stepsToDeath = 0 {
        didSet {
            if let image = UIImage(named: "\(stepsToDeath).png") {
                imageView.image = image
            } else {
                showAlert(title: "Game over!", message: "The word was: \(choosenWord.lowercased())")
                score -= 1
                startGame()
            }
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
    }
    
    func startGame() {
        choosenWord = words.remove(at: words.indices.randomElement()!)
        cryptedWord = ""
        stepsToDeath = 0
            
        setupButtons()
            
        for _ in choosenWord {
            cryptedWord += "?"
        }
    }
    
    func setupButtons() {
        activatedButtons.removeAll()
        for button in letterButtons {
            button.setTitleColor(.systemBlue, for: .normal)
            button.isEnabled = true
            button.isHidden = false
        }
    }
    
    func setupUI() {
        view = UIView()
        view.backgroundColor = .white
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "\(stepsToDeath).png")
        view.addSubview(imageView)
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        textField.font = UIFont.systemFont(ofSize: 32)
        textField.textAlignment = .center
        view.addSubview(textField)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: \(score)"
        scoreLabel.textAlignment = .right
        view.addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            textField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 40),
            textField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -40),
            
            buttonsView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let height = 42
        let width = 80
        
        for row in 0..<6 {
            for col in 0..<4 {
                createButton(row: row, col: col, height: height, width: width)
            }
        }
        createButton(row: 6, col: 0, height: height, width: width)
        createButton(row: 6, col: 1, height: height, width: width)
    }
    
    func createButton(row: Int, col: Int, height: Int, width: Int) {
        let button = UIButton(type: .system)
        button.setTitle(letters[row * 4 + col], for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
        
        let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
        button.frame = frame
        buttonsView.addSubview(button)
        letterButtons.append(button)
    }
    
    @objc func letterButtonTapped(_ sender: UIButton) {
        activatedButtons.append(sender)
        let letter = (sender.titleLabel?.text!.lowercased())!
        if choosenWord.lowercased().contains(letter) {
            sender.setTitleColor(.green, for: .normal)
            cryptedWord = changeCryptedWord(letter: letter)
            sender.isEnabled = false
        } else {
            sender.isHidden = true
            stepsToDeath += 1
        }
        
        if cryptedWord.lowercased() == choosenWord.lowercased() {
            if words.isEmpty {
                showAlert(title: "End!", message: "All words are used")
                for button in letterButtons {
                    button.setTitleColor(.systemBlue, for: .normal)
                    button.isEnabled = false
                }
            } else {
                showAlert(title: "You won!", message: "Next word...")
                score += 1
                startGame()
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func changeCryptedWord(letter: String) -> String {
        var cryptedArray = Array(cryptedWord)
        
        for (i, item) in choosenWord.enumerated() {
            if String(item).lowercased() == letter {
                cryptedArray[i] = Character(letter.uppercased())
            }
        }
        return String(cryptedArray)
    }

}

