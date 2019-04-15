
import UIKit

class ImageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                border.isHidden = false
            } else {
                border.isHidden = true
            }
        }
    }
    
    func setup() {
        self.addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
        imgView.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        imgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
        imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        
        self.addSubview(border)
        border.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive=true
        border.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive=true
        border.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive=true
        border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive=true
        border.isHidden = true
    }
    
    let imgView: UIImageView = {
        let v = UIImageView()
        v.image = UIImage()
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let border: UIView = {
        let v=UIView()
        v.backgroundColor = UIColor.clear
        v.layer.borderColor = UIColor(red: 40/255, green: 255/255, blue: 162/255, alpha: 1).cgColor
        v.layer.borderWidth = 5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
}
