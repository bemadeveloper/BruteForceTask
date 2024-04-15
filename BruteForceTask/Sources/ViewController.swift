//
//  ViewController.swift
//  BruteForceTask
//
//  Created by Bema on 15/4/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Touch me", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onBut), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        
        self.bruteForce(passwordToUnlock: "1!gr")
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setups
    
    private func setupHierarchy() {
        view.addSubview(button)
    }
    
    private func setupLayout() {
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(200)
        }
    }
    
    // MARK: - bruteForce()
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
//             Your stuff here
            print(password)
            // Your stuff here
        }
        
        print(password)
    }
    
    // MARK: - Actions
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    @objc private func onBut(_ sender: Any) {
        isBlack.toggle()
    }
}



extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }



    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }

    return str
}



