
import UIKit
import AVFoundation

public class LetterView: UIView {
    
    var backgroundHeight: NSLayoutConstraint?
    var backgroundWidth: NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        self.layer.cornerRadius = 15
        self.addSubview(background)
        self.addSubview(label)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        background.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        background.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        backgroundWidth = background.widthAnchor.constraint(equalToConstant: 0)
        backgroundWidth?.isActive = true
        backgroundHeight = background.heightAnchor.constraint(equalToConstant: 0)
        backgroundHeight?.isActive = true
        
        label.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: self.background.bottomAnchor, constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: self.background.leftAnchor, constant: 0).isActive = true
        label.rightAnchor.constraint(equalTo: self.background.rightAnchor, constant: 0).isActive = true
    }
    
    func animate() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.backgroundHeight?.constant = 40
            self.backgroundWidth?.constant = 40
            self.layoutSubviews()
            self.unlockSound.play()
        }) { (true) in
            return
        }
    }
    
    let background: UIView = {
        var v = UIView()
        v.backgroundColor = UIColor(red: 40/255, green: 255/255, blue: 162/255, alpha: 1)
        v.layer.cornerRadius = 15
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let label: UILabel = {
        var l = UILabel()
        l.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let unlockSound: AVAudioPlayer = {
        var player = AVAudioPlayer()
        let path = Bundle.main.path(forResource: "unlock.aif", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            return AVAudioPlayer()
        }
        return player
    }()
    
}
