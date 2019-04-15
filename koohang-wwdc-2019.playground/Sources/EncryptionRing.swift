
import UIKit
import AVFoundation

public class EncryptionRing: UIView {
    
    var sum: Double = 0
    var closed: Bool = false
    var padlockHeight: NSLayoutConstraint?
    var padlockWidth: NSLayoutConstraint?
    var percentageLabelHeight: NSLayoutConstraint?
    var percentageLabelWidth: NSLayoutConstraint?
    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let pulseLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 210, height: 256))
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.addSubview(title)
        setupRing()
        self.addSubview(padlock)
        self.addSubview(percentageLabel)
        setup()
        pulse()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        title.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        padlock.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -78).isActive = true
        padlock.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        padlockWidth = padlock.widthAnchor.constraint(equalToConstant: 0)
        padlockWidth?.isActive = true
        padlockHeight = padlock.heightAnchor.constraint(equalToConstant: 0)
        padlockHeight?.isActive = true
        
        percentageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -78).isActive = true
        percentageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        percentageLabelWidth = percentageLabel.widthAnchor.constraint(equalToConstant: 75)
        percentageLabelWidth?.isActive = true
        percentageLabelHeight = percentageLabel.heightAnchor.constraint(equalToConstant: 30)
        percentageLabelHeight?.isActive = true
    }
    
    private func setupRing() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 40/255, green: 255/255, blue: 162/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 12
        shapeLayer.strokeEnd = 0
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.position = CGPoint(x: self.center.x, y: self.center.y + 35)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(red: 40/255, green: 255/255, blue: 162/255, alpha: 0.4).cgColor
        trackLayer.lineWidth = 12
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.position = CGPoint(x: self.center.x, y: self.center.y + 35)
        
        pulseLayer.path = circularPath.cgPath
        pulseLayer.strokeColor = UIColor.clear.cgColor
        pulseLayer.lineWidth = 12
        pulseLayer.fillColor = UIColor(red: 40/255, green: 255/255, blue: 162/255, alpha: 0.2).cgColor
        pulseLayer.lineCap = .round
        pulseLayer.position = CGPoint(x: self.center.x, y: self.center.y + 35)
        
        self.layer.addSublayer(pulseLayer)
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(shapeLayer)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = sum
        animation.toValue = (sum + Double(location.x) / 1000)
        sum = Double(sum + Double(location.x) / 1000)
        
        if sum * 100 > 100.0 {
            percentageLabel.text = "100 %"
        } else {
            percentageLabel.text = "\(Int(sum * 100)) %"
        }
        
        animation.duration = 0.1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
        
        if sum > 1 {
            closed = true
            self.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5) {
                self.percentageLabelHeight?.constant = 0
                self.percentageLabelWidth?.constant = 0
                self.layoutSubviews()
            }
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.padlockHeight?.constant = 30
                self.padlockWidth?.constant = 30
                self.layoutSubviews()
                self.lockSound.play()
            }) { (true) in
                return
            }
        }
        
    }
    
    func pulse() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.9
        animation.toValue = 1.5
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pulseLayer.add(animation, forKey: "pulse")
    }
    
    let title: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "title"
        l.font = UIFont.boldSystemFont(ofSize: 32)
        l.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        l.textAlignment = .center
        return l
    }()
    
    let padlock: UIImageView = {
        var iv = UIImageView(image: UIImage(named: "padlock.png"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let percentageLabel: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        l.textAlignment = .center
        return l
    }()
    
    let lockSound: AVAudioPlayer = {
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
    
}

