
import UIKit
import AVFoundation

public class Padlock: UIView {
        
    var lockSound: AVAudioPlayer = {
        var player = AVAudioPlayer()
        let path = Bundle.main.path(forResource: "lock.aif", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            return AVAudioPlayer()
        }
        return player
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 768, height: 452))
        self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        self.backgroundColor = .black
        self.layer.borderColor = UIColor(red: 253/255, green: 35/255, blue: 35/255, alpha: 1).cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 35
        self.addSubview(padImageView)
        self.addSubview(lockImageView)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc public func lock() {
        UIView.animate(withDuration: 0.1) {
            self.lockImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.lockImageView.transform = CGAffineTransform(translationX: -30, y: 10)
            self.padImageView.transform = CGAffineTransform(translationX: 20, y: 0)
            self.layer.borderColor = UIColor(red: 40/255, green: 255/255, blue: 162/255, alpha: 1).cgColor
        }
        lockSound.play()
        self.isUserInteractionEnabled = false
    }
    
    public func setup() {
        padImageView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        padImageView.heightAnchor.constraint(equalToConstant: 62).isActive = true
        padImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20).isActive = true
        padImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -20).isActive = true
        
        lockImageView.widthAnchor.constraint(equalToConstant: 78).isActive = true
        lockImageView.heightAnchor.constraint(equalToConstant: 62).isActive = true
        lockImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
        lockImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 30).isActive = true
    }
    
    let padImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "pad.png")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let lockImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "lock.png")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
}
