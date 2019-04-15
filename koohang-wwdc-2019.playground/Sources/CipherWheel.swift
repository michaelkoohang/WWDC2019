
import UIKit
import AVFoundation

public class CipherWheel: UIView {
    
    var index: Int = 0
    var angle: CGFloat = 0
    var currentLetter: String = "A"
    var cipherLetters = ["A", "B", "O", "D", "E", "L", "G", "I", "H", "S", "C", "P"]
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 15
        self.addSubview(plaintextWheel)
        self.addSubview(ciphertextWheel)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc public func rotateRight() {
        index = index - 1
        if index < 0 {
            if (index == -12) {
                index = 0
                currentLetter = cipherLetters[index]
            } else {
                currentLetter = cipherLetters[index + 12]
            }
        } else {
            currentLetter = cipherLetters[index]
        }

        angle = angle + CGFloat.pi / 6
        UIView.animate(withDuration: 0.2) {
            self.leftButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.leftButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.ciphertextWheel.transform = CGAffineTransform(rotationAngle: self.angle)
            self.rotateSound.play()
        }
    }
    
    @objc public func rotateLeft() {
        index = index + 1
        if index >= 0 {
            if (index == 12) {
                index = 0
            }
            currentLetter = cipherLetters[index]
        } else {
            currentLetter = cipherLetters[index + 12]
        }
        
        angle = angle - CGFloat.pi / 6
        UIView.animate(withDuration: 0.2) {
            self.rightButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.rightButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.ciphertextWheel.transform = CGAffineTransform(rotationAngle: self.angle)
            self.rotateSound.play()
        }
    }
    
    public func setup() {
        plaintextWheel.widthAnchor.constraint(equalToConstant: 215).isActive = true
        plaintextWheel.heightAnchor.constraint(equalToConstant: 215).isActive = true
        plaintextWheel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        plaintextWheel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        ciphertextWheel.widthAnchor.constraint(equalToConstant: 167).isActive = true
        ciphertextWheel.heightAnchor.constraint(equalToConstant: 167).isActive = true
        ciphertextWheel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        ciphertextWheel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        leftButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        leftButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        
        rightButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        rightButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
    }
    
    let rotateSound: AVAudioPlayer = {
        var player = AVAudioPlayer()
        let path = Bundle.main.path(forResource: "click.aif", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            return AVAudioPlayer()
        }
        return player
    }()
    
    let plaintextWheel: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "plaintext-wheel.png")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let ciphertextWheel: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "ciphertext-wheel.png")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let leftButton: UIButton = {
        var b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(rotateRight), for: .touchUpInside)
        b.setImage(UIImage(named: "rotate-button-left"), for: .normal)
        b.adjustsImageWhenHighlighted = false
        return b
    }()
    
    let rightButton: UIButton = {
        var b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(rotateLeft), for: .touchUpInside)
        b.setImage(UIImage(named: "rotate-button-right"), for: .normal)
        b.adjustsImageWhenHighlighted = false
        return b
    }()
    
}
