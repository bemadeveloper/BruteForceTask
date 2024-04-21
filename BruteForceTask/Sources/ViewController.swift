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

    
    private lazy var buttonToChangeColor: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Change color", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onBut), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private lazy var buttonToGeneratePassword: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Generate password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(generatingButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelToShow: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemPink
        
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        return indicator
    }()
    
    // MARK: - bruteForce()
    let globalQueue = DispatchQueue(label: "concurrent-queue",qos: .utility, attributes: .concurrent)
    var isPasswordGenerated = false
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        
        //bruteForce.bruteForce(passwordToUnlock: textField.text!)
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setups
    
    private func setupHierarchy() {
        view.addSubview(buttonToChangeColor)
        view.addSubview(buttonToGeneratePassword)
        view.addSubview(labelToShow)
        view.addSubview(textField)
        view.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        buttonToChangeColor.snp.makeConstraints { make in
            make.bottom.equalTo(textField).offset(200)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        textField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(250)
        }
        buttonToGeneratePassword.snp.makeConstraints { make in
            make.bottom.equalTo(textField).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        labelToShow.snp.makeConstraints { make in
            make.bottom.equalTo(textField).offset(-30)
            make.left.equalTo(180)
            make.height.equalTo(50)
            make.width.equalTo(80)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(textField.snp.left).offset(-8)
            
        }
        
    }
    
    // MARK: - Actions
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .systemTeal
            } else {
                self.view.backgroundColor = .systemMint
            }
        }
    }
    
    @objc private func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    @objc private func generatingButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        textField.isSecureTextEntry = true
        if let password = textField.text, !isPasswordGenerated {
            bruteForce(passwordToUnlock: password)
        }
    }
    
    func bruteForce(passwordToUnlock: String) {
        globalQueue.async {
            let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
            
            var password: String = ""
        
            // Will strangely ends at 0000 instead of ~~~
            while password != passwordToUnlock && !self.isPasswordGenerated { // Increase MAXIMUM_PASSWORD_SIZE value for more
                password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
                //             Your stuff here
                DispatchQueue.main.async {
                    self.labelToShow.text = "\(password)"
                }
                print(password)
                // Your stuff here
            }
            
            print(password)
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.labelToShow.text = password
                self.textField.isSecureTextEntry = false
                self.isPasswordGenerated = true
            }
        }
    }
}

let queueForGenerating = DispatchQueue(label: "queueForGenerating", attributes: .concurrent)

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




