
import UIKit
import AVFoundation

public class Main: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Puzzles View Variables
    var puzzleTitleY: NSLayoutConstraint?
    var padlock1Y: NSLayoutConstraint?
    var padlock2Y: NSLayoutConstraint?
    var padlock3Y: NSLayoutConstraint?
    var checkWidth: NSLayoutConstraint?
    var checkHeight: NSLayoutConstraint?
    
    // Puzzle 1 Variables
    var p1TitleY: NSLayoutConstraint?
    var p1ExitButtonY: NSLayoutConstraint?
    var photosRingY: NSLayoutConstraint?
    var messageRingY: NSLayoutConstraint?
    var payRingY: NSLayoutConstraint?
    var currentKeyLetter: String = "I"
    
    // Puzzle 2 Variables
    var p2TitleY: NSLayoutConstraint?
    var p2ExitButtonY: NSLayoutConstraint?
    var p2InstructionsY: NSLayoutConstraint?
    var decryptedMessageViewY: NSLayoutConstraint?
    var cipherWheelY: NSLayoutConstraint?
    
    // Puzzle 3 Variables
    var p3TitleY: NSLayoutConstraint?
    var p3ExitButtonY: NSLayoutConstraint?
    var p3InstructionsY: NSLayoutConstraint?
    var originalPhotoY: NSLayoutConstraint?
    var puzzle3Y: NSLayoutConstraint?
    let questionImageArray = [UIImage(named: "i8.jpg")!,
                              UIImage(named: "i3.jpg")!,
                              UIImage(named: "i2.jpg")!,
                              UIImage(named: "i9.jpg")!,
                              UIImage(named: "i7.jpg")!,
                              UIImage(named: "i4.jpg")!,
                              UIImage(named: "i6.jpg")!,
                              UIImage(named: "i1.jpg")!,
                              UIImage(named: "i5.jpg")!]
    let correctAns = [7,2,1,5,8,6,4,0,3]
    var wrongAns = Array(0..<9)
    var wrongImageArray = [UIImage]()
    var undoMovesArray = [(first: IndexPath, second: IndexPath)]()
    var firstIndexPath: IndexPath?
    var secondIndexPath: IndexPath?
    
    // Main UIView
    public override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 768, height: 452))
        self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        
        // Start View
        self.addSubview(greeting)
        self.addSubview(image)
        self.addSubview(message)
        self.addSubview(startButton)
        
        // Puzzles View
        self.addSubview(puzzleTitle)
        self.addSubview(padlock1)
        self.addSubview(padlock2)
        self.addSubview(padlock3)
        self.addSubview(check)
        padlock1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPuzzle1)))
        padlock2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPuzzle2)))
        padlock3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPuzzle3)))
        
        // Puzzle 1
        self.addSubview(p1Title)
        self.addSubview(p1ExitButton)
        self.addSubview(photoRing)
        self.addSubview(messageRing)
        self.addSubview(payRing)
        photoRing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkRing)))
        messageRing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkRing)))
        payRing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkRing)))
        
        // Puzzle 2
        self.addSubview(p2Title)
        self.addSubview(p2ExitButton)
        self.addSubview(p2Instructions)
        self.addSubview(decryptedMessageView)
        self.addSubview(viewW1)
        self.addSubview(viewW2)
        self.addSubview(viewD)
        self.addSubview(viewC)
        self.addSubview(view1)
        self.addSubview(view9)
        self.addSubview(cipherWheel)
        cipherWheel.leftButton.addTarget(self, action: #selector(decryptMessage), for: .touchUpInside)
        cipherWheel.rightButton.addTarget(self, action: #selector(decryptMessage), for: .touchUpInside)
        
        // Puzzle 3
        self.addSubview(p3Title)
        self.addSubview(p3ExitButton)
        self.addSubview(p3Instructions)
        self.addSubview(originalPhoto)
        puzzle3.addSubview(collectionView)
        wrongImageArray = questionImageArray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        self.addSubview(puzzle3)
        
        // Closing
        self.addSubview(iphone)
        self.addSubview(closingMessage)
        self.addSubview(closingImage)
        self.addSubview(name)
        self.addSubview(closingPadlock)
        
        setupConstraints()
        showStartView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setupConstraints() {
        
        // Start View Constraints
        greeting.widthAnchor.constraint(equalToConstant: 264).isActive = true
        greeting.heightAnchor.constraint(equalToConstant: 52).isActive = true
        greeting.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64).isActive = true
        greeting.topAnchor.constraint(equalTo: self.topAnchor, constant: 36).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 175).isActive = true
        image.heightAnchor.constraint(equalToConstant: 175).isActive = true
        image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64).isActive = true
        image.topAnchor.constraint(equalTo: greeting.bottomAnchor, constant: 36).isActive = true
        
        message.widthAnchor.constraint(equalToConstant: 415).isActive = true
        message.heightAnchor.constraint(equalToConstant: 175).isActive = true
        message.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 45).isActive = true
        message.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        
        startButton.widthAnchor.constraint(equalToConstant: 125).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64).isActive = true
        startButton.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 48).isActive = true
        
        // Puzzles View Constraints
        puzzleTitle.widthAnchor.constraint(equalToConstant: 600).isActive = true
        puzzleTitle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        puzzleTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        puzzleTitleY = puzzleTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: -200)
        puzzleTitleY?.isActive = true
        
        padlock1.widthAnchor.constraint(equalToConstant: 165).isActive = true
        padlock1.heightAnchor.constraint(equalToConstant: 165).isActive = true
        padlock1.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -225).isActive = true
        padlock1Y = padlock1.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 500)
        padlock1Y?.isActive = true
        
        padlock2.widthAnchor.constraint(equalToConstant: 165).isActive = true
        padlock2.heightAnchor.constraint(equalToConstant: 165).isActive = true
        padlock2.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        padlock2Y = padlock2.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 500)
        padlock2Y?.isActive = true
        
        padlock3.widthAnchor.constraint(equalToConstant: 165).isActive = true
        padlock3.heightAnchor.constraint(equalToConstant: 165).isActive = true
        padlock3.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 225).isActive = true
        padlock3Y = padlock3.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 500)
        padlock3Y?.isActive = true
        
        check.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        check.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        checkWidth = check.widthAnchor.constraint(equalToConstant: 0)
        checkWidth?.isActive = true
        checkHeight = check.heightAnchor.constraint(equalToConstant: 0)
        checkHeight?.isActive = true
        
        // Puzzle 1 Constraints
        p1Title.widthAnchor.constraint(equalToConstant: 650).isActive = true
        p1Title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        p1Title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        p1TitleY = p1Title.topAnchor.constraint(equalTo: self.topAnchor, constant: -200)
        p1TitleY?.isActive = true
        
        p1ExitButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        p1ExitButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        p1ExitButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        p1ExitButtonY = p1ExitButton.centerYAnchor.constraint(equalTo: self.p1Title.centerYAnchor, constant: -200)
        p1ExitButtonY?.isActive = true
        
        messageRing.widthAnchor.constraint(equalToConstant: 210).isActive = true
        messageRing.heightAnchor.constraint(equalToConstant: 256).isActive = true
        messageRing.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageRingY = messageRing.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 700)
        messageRingY?.isActive = true
        
        photoRing.widthAnchor.constraint(equalToConstant: 210).isActive = true
        photoRing.heightAnchor.constraint(equalToConstant: 256).isActive = true
        photoRing.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -235).isActive = true
        photosRingY = photoRing.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 700)
        photosRingY?.isActive = true
        
        payRing.widthAnchor.constraint(equalToConstant: 210).isActive = true
        payRing.heightAnchor.constraint(equalToConstant: 256).isActive = true
        payRing.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 235).isActive = true
        payRingY = payRing.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 700)
        payRingY?.isActive = true
        
        // Puzzle 2 Constraints
        p2Title.widthAnchor.constraint(equalToConstant: 650).isActive = true
        p2Title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        p2Title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        p2TitleY = p2Title.topAnchor.constraint(equalTo: self.topAnchor, constant: -200)
        p2TitleY?.isActive = true
        
        p2ExitButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        p2ExitButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        p2ExitButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        p2ExitButtonY = p2ExitButton.centerYAnchor.constraint(equalTo: self.p2Title.centerYAnchor, constant: -200)
        p2ExitButtonY?.isActive = true
        
        p2Instructions.widthAnchor.constraint(equalToConstant: 360).isActive = true
        p2Instructions.heightAnchor.constraint(equalToConstant: 175).isActive = true
        p2Instructions.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        p2InstructionsY = p2Instructions.topAnchor.constraint(equalTo: self.p2Title.bottomAnchor, constant: 700)
        p2InstructionsY?.isActive = true
        
        decryptedMessageView.widthAnchor.constraint(equalToConstant: 360).isActive = true
        decryptedMessageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        decryptedMessageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        decryptedMessageViewY = decryptedMessageView.topAnchor.constraint(equalTo: self.p2Instructions.bottomAnchor, constant: 700)
        decryptedMessageViewY?.isActive = true
        
        viewW1.widthAnchor.constraint(equalToConstant: 40).isActive = true
        viewW1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewW1.leftAnchor.constraint(equalTo: self.decryptedMessageView.leftAnchor, constant: 16).isActive = true
        viewW1.topAnchor.constraint(equalTo: self.decryptedMessageView.topAnchor, constant: 44).isActive = true
        
        viewW2.widthAnchor.constraint(equalToConstant: 40).isActive = true
        viewW2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewW2.leftAnchor.constraint(equalTo: self.viewW1.leftAnchor, constant: 57).isActive = true
        viewW2.centerYAnchor.constraint(equalTo: self.viewW1.centerYAnchor, constant: 0).isActive = true
        
        viewD.widthAnchor.constraint(equalToConstant: 40).isActive = true
        viewD.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewD.leftAnchor.constraint(equalTo: self.viewW2.leftAnchor, constant: 57).isActive = true
        viewD.centerYAnchor.constraint(equalTo: self.viewW2.centerYAnchor, constant: 0).isActive = true
        
        viewC.widthAnchor.constraint(equalToConstant: 40).isActive = true
        viewC.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewC.leftAnchor.constraint(equalTo: self.viewD.leftAnchor, constant: 57).isActive = true
        viewC.centerYAnchor.constraint(equalTo: self.viewD.centerYAnchor, constant: 0).isActive = true
        
        view1.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view1.leftAnchor.constraint(equalTo: self.viewC.leftAnchor, constant: 57).isActive = true
        view1.centerYAnchor.constraint(equalTo: self.viewC.centerYAnchor, constant: 0).isActive = true
        
        view9.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view9.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view9.leftAnchor.constraint(equalTo: self.view1.leftAnchor, constant: 57).isActive = true
        view9.centerYAnchor.constraint(equalTo: self.view1.centerYAnchor, constant: 0).isActive = true
        
        cipherWheel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        cipherWheel.heightAnchor.constraint(equalToConstant: 300).isActive = true
        cipherWheel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        cipherWheelY = cipherWheel.topAnchor.constraint(equalTo: self.p2Title.bottomAnchor, constant: 700)
        cipherWheelY?.isActive = true
        
        // Puzzle 3 Constraints
        p3Title.widthAnchor.constraint(equalToConstant: 650).isActive = true
        p3Title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        p3Title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        p3TitleY = p3Title.topAnchor.constraint(equalTo: self.topAnchor, constant: -200)
        p3TitleY?.isActive = true
        
        p3ExitButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        p3ExitButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        p3ExitButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        p3ExitButtonY = p3ExitButton.centerYAnchor.constraint(equalTo: self.p3Title.centerYAnchor, constant: -200)
        p3ExitButtonY?.isActive = true
        
        p3Instructions.widthAnchor.constraint(equalToConstant: 325).isActive = true
        p3Instructions.heightAnchor.constraint(equalToConstant: 150).isActive = true
        p3Instructions.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        p3InstructionsY = p3Instructions.topAnchor.constraint(equalTo: self.p3Title.bottomAnchor, constant: 700)
        p3InstructionsY?.isActive = true
        
        originalPhoto.widthAnchor.constraint(equalToConstant: 325).isActive = true
        originalPhoto.heightAnchor.constraint(equalToConstant: 150).isActive = true
        originalPhoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 36).isActive = true
        originalPhotoY = originalPhoto.topAnchor.constraint(equalTo: self.p3Instructions.bottomAnchor, constant: 700)
        originalPhotoY?.isActive = true
        
        puzzle3.widthAnchor.constraint(equalToConstant: 325).isActive = true
        puzzle3.heightAnchor.constraint(equalToConstant: 325).isActive = true
        puzzle3.leftAnchor.constraint(equalTo: self.p3Instructions.rightAnchor, constant: 36).isActive = true
        puzzle3Y = puzzle3.topAnchor.constraint(equalTo: self.p3Instructions.topAnchor, constant: 700)
        puzzle3Y?.isActive = true
        
        collectionView.leftAnchor.constraint(equalTo: puzzle3.leftAnchor, constant: 20).isActive=true
        collectionView.topAnchor.constraint(equalTo: puzzle3.topAnchor, constant: 20).isActive=true
        collectionView.rightAnchor.constraint(equalTo: puzzle3.rightAnchor, constant: -20).isActive=true
        collectionView.bottomAnchor.constraint(equalTo: puzzle3.bottomAnchor, constant: -20).isActive=true
        
        // Closing constraints
        iphone.widthAnchor.constraint(equalToConstant: 250).isActive = true
        iphone.heightAnchor.constraint(equalToConstant: 385).isActive = true
        iphone.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64).isActive = true
        iphone.topAnchor.constraint(equalTo: self.topAnchor, constant: 36).isActive = true
        
        closingMessage.widthAnchor.constraint(equalToConstant: 350).isActive = true
        closingMessage.leftAnchor.constraint(equalTo: iphone.rightAnchor, constant: 45).isActive = true
        closingMessage.topAnchor.constraint(equalTo: iphone.topAnchor).isActive = true
        
        closingImage.widthAnchor.constraint(equalToConstant: 125).isActive = true
        closingImage.heightAnchor.constraint(equalToConstant: 125).isActive = true
        closingImage.leftAnchor.constraint(equalTo: closingMessage.leftAnchor, constant: 0).isActive = true
        closingImage.topAnchor.constraint(equalTo: closingMessage.bottomAnchor, constant: 24).isActive = true
        
        name.widthAnchor.constraint(equalToConstant: 200).isActive = true
        name.heightAnchor.constraint(equalToConstant: 125).isActive = true
        name.leftAnchor.constraint(equalTo: closingImage.rightAnchor, constant: 16).isActive = true
        name.centerYAnchor.constraint(equalTo: closingImage.centerYAnchor, constant: 0).isActive = true
        
        closingPadlock.heightAnchor.constraint(equalToConstant: 50).isActive = true
        closingPadlock.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closingPadlock.centerXAnchor.constraint(equalTo: iphone.centerXAnchor, constant: 0).isActive = true
        closingPadlock.centerYAnchor.constraint(equalTo: iphone.centerYAnchor).isActive = true
    }
    
    // Start View Components
    let greeting: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Hi There!👋"
        l.font = UIFont.boldSystemFont(ofSize: 48)
        l.textColor = .white
        l.alpha = 0
        return l
    }()
    
    let image: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "profile.jpg")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        iv.alpha = 0
        return iv
    }()
    
    let message: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Nice to meet you! My name is Michael, I’m 18 years old, " +
        "and I’m a software engineering undergrad from the state of Georgia. Enjoy my playground 😁"
        l.font = UIFont.systemFont(ofSize: 28, weight: .light)
        l.textColor = .white
        l.numberOfLines = 5
        l.lineBreakMode = .byWordWrapping
        l.alpha = 0
        return l
    }()
    
    let startButton: UIButton = {
        var b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(showPuzzlesView), for: .touchUpInside)
        b.setTitle("Start", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        b.backgroundColor = .white
        b.setTitleColor(.black, for: .normal)
        b.layer.cornerRadius = 15
        b.alpha = 0
        return b
    }()
    
    // Puzzles View Components
    let puzzleTitle: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "I just got a new iPhone! Solve each puzzle to help protect my privacy!"
        l.font = UIFont.boldSystemFont(ofSize: 36)
        l.numberOfLines = 2
        l.textColor = .white
        l.textAlignment = .left
        return l
    }()
    
    let padlock1: Padlock = {
        var v = Padlock()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let padlock2: Padlock = {
        var v = Padlock()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let padlock3: Padlock = {
        var v = Padlock()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let check: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "check.png")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var dingSound: AVAudioPlayer = {
        var player = AVAudioPlayer()
        let path = Bundle.main.path(forResource: "ding.aif", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            return AVAudioPlayer()
        }
        return player
    }()
    
    // Puzzle 1 Components
    let p1Title: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Close the rings to encrypt my data!"
        l.font = UIFont.boldSystemFont(ofSize: 32)
        l.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        return l
    }()
    
    let p1ExitButton: UIButton = {
        var b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(dismissPuzzle1Incomplete), for: .touchUpInside)
        b.setImage(UIImage(named: "exit.png"), for: .normal)
        return b
    }()
    
    let photoRing: EncryptionRing = {
        var ring = EncryptionRing()
        ring.title.text = "Photos"
        ring.translatesAutoresizingMaskIntoConstraints = false
        return ring
    }()
    
    let messageRing: EncryptionRing = {
        var ring = EncryptionRing()
        ring.title.text = "Messages"
        ring.translatesAutoresizingMaskIntoConstraints = false
        return ring
    }()
    
    let payRing: EncryptionRing = {
        var ring = EncryptionRing()
        ring.title.text = "Apple Pay"
        ring.translatesAutoresizingMaskIntoConstraints = false
        return ring
    }()
    
    // Puzzle 2 Components
    let p2Title: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Decrypt the iMessage!"
        l.font = UIFont.boldSystemFont(ofSize: 32)
        l.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        return l
    }()
    
    let p2ExitButton: UIButton = {
        var b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(dismissPuzzle2Incomplete), for: .touchUpInside)
        b.setImage(UIImage(named: "exit.png"), for: .normal)
        return b
    }()
    
    let p2Instructions: UIView = {
        var v = UIView()
        var l = UILabel()
        var i = UILabel()
        
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.addSubview(l)
        v.addSubview(i)
        l.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        l.text = "Instructions"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.topAnchor.constraint(equalTo: v.topAnchor, constant: 10).isActive = true
        l.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 16).isActive = true
        i.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        i.text = "Decrypt the message \"AILGSD\" by using the key \"IOSAPP\" in the cipher wheel. Find the first letter of the key in the gray circle. Turn the circle to align that letter with the letter A on the black circle. Repeat this for all the letters in the key."
        i.numberOfLines = 8
        i.lineBreakMode = .byWordWrapping
        i.translatesAutoresizingMaskIntoConstraints = false
        i.topAnchor.constraint(equalTo: l.bottomAnchor, constant: 10).isActive = true
        i.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 16).isActive = true
        i.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -16).isActive = true
        
        return v
    }()
    
    let decryptedMessageView: UIView = {
        var v = UIView()
        var l = UILabel()
        
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.addSubview(l)
        l.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        l.text = "Decrypted iMessage"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.topAnchor.constraint(equalTo: v.topAnchor, constant: 10).isActive = true
        l.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 16).isActive = true
        
        return v
    }()
    
    let viewW1: LetterView = {
        var v = LetterView()
        v.label.text = "W"
        v.background.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let viewW2: LetterView = {
        var v = LetterView()
        v.label.text = "W"
        v.background.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let viewD: LetterView = {
        var v = LetterView()
        v.label.text = "D"
        v.background.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let viewC: LetterView = {
        var v = LetterView()
        v.label.text = "C"
        v.background.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let view1: LetterView = {
        var v = LetterView()
        v.label.text = "1"
        v.background.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let view9: LetterView = {
        var v = LetterView()
        v.label.text = "9"
        v.background.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let cipherWheel: CipherWheel = {
        var cw = CipherWheel()
        cw.translatesAutoresizingMaskIntoConstraints = false
        return cw
    }()
    
    
    // Puzzle 3 Components
    let p3Title: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Complete the FaceID setup!"
        l.font = UIFont.boldSystemFont(ofSize: 32)
        l.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        return l
    }()
    
    let p3ExitButton: UIButton = {
        var b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(dismissPuzzle3Incomplete), for: .touchUpInside)
        b.setImage(UIImage(named: "exit.png"), for: .normal)
        return b
    }()
    
    let p3Instructions: UIView = {
        var v = UIView()
        var l = UILabel()
        var i = UILabel()
        
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.addSubview(l)
        v.addSubview(i)
        l.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        l.text = "Instructions"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.topAnchor.constraint(equalTo: v.topAnchor, constant: 10).isActive = true
        l.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 16).isActive = true
        i.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        i.text = "Solve the puzzle by rearranging the squares so FaceID can recognize me! Tap two squares to swap them with each other."
        i.numberOfLines = 8
        i.lineBreakMode = .byWordWrapping
        i.translatesAutoresizingMaskIntoConstraints = false
        i.topAnchor.constraint(equalTo: l.bottomAnchor, constant: 10).isActive = true
        i.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 16).isActive = true
        i.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -16).isActive = true
        
        return v
    }()
    
    let originalPhoto: UIView = {
        var v = UIView()
        var l = UILabel()
        var i = UIImageView()
        
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.addSubview(l)
        v.addSubview(i)
        l.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        l.text = "Original\nPhoto"
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        l.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: 0).isActive = true
        l.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 16).isActive = true
        i.image = UIImage(named: "profile.jpg")
        i.layer.masksToBounds = true
        i.layer.cornerRadius = 15
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        i.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: 0).isActive = true
        i.rightAnchor.constraint(equalTo: v.rightAnchor, constant: -24).isActive = true
        i.heightAnchor.constraint(equalToConstant: 110).isActive = true
        i.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        return v
    }()
    
    let puzzle3: UIView = {
        let p = UIView()
        p.backgroundColor = UIColor.white
        p.layer.cornerRadius = 15
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 325, height: 325), collectionViewLayout: layout)
        cv.allowsMultipleSelection = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // Closing components
    let iphone: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "iphone.png")
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0
        return iv
    }()
    
    let closingMessage: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Privacy is a fundamental human right, and it's up to every single one of us to protect it. Thank you, " +
        "Apple, for fighting for our right to privacy. Hope to see you at WWDC 😉.\n\nYour's truly,"
        l.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        l.textColor = .white
        l.numberOfLines = 9
        l.lineBreakMode = .byWordWrapping
        l.alpha = 0
        return l
    }()
    
    let closingImage: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "profile.jpg")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        iv.alpha = 0
        return iv
    }()
    
    let name: UILabel = {
        var l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Michael\nKoohang"
        l.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        l.textColor = .white
        l.numberOfLines = 2
        l.lineBreakMode = .byWordWrapping
        l.alpha = 0
        return l
    }()
    
    let closingPadlock: Padlock = {
       var p = Padlock()
        p.layer.borderWidth = 0
        p.alpha = 0
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    // Start View Functions
    @objc public func showStartView() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.greeting.alpha = 1
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseIn, animations: {
            self.image.alpha = 1
            self.message.alpha = 1
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseIn, animations: {
            self.startButton.alpha = 1
        }) { (true) in
            return
        }
    }
    
    @objc public func showPuzzlesView() {
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
            self.greeting.transform = CGAffineTransform(translationX: -20, y: 0)
            self.greeting.alpha = 0
            self.startButton.transform = CGAffineTransform(translationX: -20, y: 0)
            self.startButton.alpha = 0
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
            self.image.transform = CGAffineTransform(translationX: -20, y: 0)
            self.image.alpha = 0
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
            self.message.transform = CGAffineTransform(translationX: -20, y: 0)
            self.message.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
                self.puzzleTitleY!.constant = 30
                self.layoutSubviews()
            }) { (true) in
                return
            }
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
                self.padlock1Y!.constant = 50
                self.layoutSubviews()
            }) { (true) in
                return
            }
            
            UIView.animate(withDuration: 1, delay: 0.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
                self.padlock2Y!.constant = 50
                self.layoutSubviews()
            }) { (true) in
                return
            }
            
            UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
                self.padlock3Y!.constant = 50
                self.layoutSubviews()
            }) { (true) in
                self.closingAnimation()
            }
        }
        
    }
    
    // Puzzle 1 Functions
    @objc public func showPuzzle1() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.2, options: .curveEaseOut, animations: {
            self.puzzleTitleY?.constant = -200
            self.padlock1Y?.constant = 500
            self.padlock2Y?.constant = 500
            self.padlock3Y?.constant = 500
            self.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.75, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p1TitleY?.constant = 30
            self.p1ExitButtonY?.constant = 0
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.75, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.photosRingY?.constant = 25
            self.messageRingY?.constant = 25
            self.payRingY?.constant = 25
            self.layoutSubviews()
        }) { (true) in
            return
        }
    }
    
    @objc public func dismissPuzzle1Incomplete() {
        UIView.animate(withDuration: 1.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p1TitleY?.constant = -200
            self.p1ExitButtonY?.constant = -200
            self.photosRingY?.constant = 700
            self.messageRingY?.constant = 700
            self.payRingY?.constant = 700
            self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
            self.layoutSubviews()
        }) { (true) in
            return
        }
 
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.puzzleTitleY!.constant = 30
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 0.75, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock1Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock2Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 1.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock3Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
    }
    
    @objc public func dismissPuzzle1Complete() {
        
        UIView.animate(withDuration: 1.75, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p1TitleY?.constant = -200
            self.p1ExitButtonY?.constant = -200
            self.photosRingY?.constant = 700
            self.messageRingY?.constant = 700
            self.payRingY?.constant = 700
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.8, delay: 1.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            self.checkHeight?.constant = 100
            self.checkWidth?.constant = 100
            self.layoutSubviews()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                self.dingSound.play()
            })
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.8, delay: 3.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            self.checkHeight?.constant = 0
            self.checkWidth?.constant = 0
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 3.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 3.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.puzzleTitleY!.constant = 30
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 3.50, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock1Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            self.padlock1.lock()
        }
        
        UIView.animate(withDuration: 1, delay: 3.75, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock2Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 4, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock3Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
    }
    
    @objc func checkRing() {
        if photoRing.closed == true && messageRing.closed == true && payRing.closed == true {
            dismissPuzzle1Complete()
        }
    }
    
    // Puzzle 2 Functions
    @objc public func showPuzzle2() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseOut, animations: {
            self.puzzleTitleY?.constant = -200
            self.padlock1Y?.constant = 500
            self.padlock2Y?.constant = 500
            self.padlock3Y?.constant = 500
            self.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.75, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p2TitleY?.constant = 30
            self.p2ExitButtonY?.constant = 0
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.75, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p2InstructionsY?.constant = 25
            self.decryptedMessageViewY?.constant = 25
            self.cipherWheelY?.constant = 25
            self.layoutSubviews()
        }) { (true) in
            return
        }
    }
    
    @objc public func dismissPuzzle2Incomplete() {
        UIView.animate(withDuration: 1.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p2TitleY?.constant = -200
            self.p2ExitButtonY?.constant = -200
            self.p2InstructionsY?.constant = 700
            self.decryptedMessageViewY?.constant = 700
            self.cipherWheelY?.constant = 700
            self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.puzzleTitleY!.constant = 30
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 0.75, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock1Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock2Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 1.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock3Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
    }
    
    @objc public func dismissPuzzle2Complete() {
        UIView.animate(withDuration: 1.75, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p2TitleY?.constant = -200
            self.p2ExitButtonY?.constant = -200
            self.p2InstructionsY?.constant = 700
            self.decryptedMessageViewY?.constant = 700
            self.cipherWheelY?.constant = 700
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.8, delay: 1.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            self.checkHeight?.constant = 100
            self.checkWidth?.constant = 100
            self.layoutSubviews()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                self.dingSound.play()
            })
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.8, delay: 3.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            self.checkHeight?.constant = 0
            self.checkWidth?.constant = 0
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 3.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 3.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.puzzleTitleY!.constant = 30
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 3.50, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock1Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 3.75, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock2Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            self.padlock2.lock()
        }
        
        UIView.animate(withDuration: 1, delay: 4, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock3Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
    }
    
    @objc func decryptMessage() {
        if currentKeyLetter == cipherWheel.currentLetter {
            switch currentKeyLetter {
            case "I":
                viewW1.animate()
                currentKeyLetter = "O"
            case "O":
                viewW2.animate()
                currentKeyLetter = "S"
            case "S":
                viewD.animate()
                currentKeyLetter = "A"
            case "A":
                viewC.animate()
                currentKeyLetter = "P"
            case "P":
                view1.animate()
                view9.animate()
                dismissPuzzle2Complete()
            default:
                return
            }
        }
    }
    
    // Puzzle 3 Functions
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
        cell.imgView.image = questionImageArray[indexPath.item]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if firstIndexPath == nil {
            firstIndexPath = indexPath
            collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else if secondIndexPath == nil {
            secondIndexPath = indexPath
            collectionView.deselectItem(at: firstIndexPath!, animated: true)
            swap()
        } else {
            return
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath == firstIndexPath {
            firstIndexPath = nil
        } else if indexPath == secondIndexPath {
            secondIndexPath = nil
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/3, height: width/3)
    }
    
    public func swap() {
        guard let start = firstIndexPath, let end = secondIndexPath else { return }
        collectionView.performBatchUpdates({
            collectionView.moveItem(at: start, to: end)
            collectionView.moveItem(at: end, to: start)
        }) { (done) in
            self.collectionView.deselectItem(at: start, animated: true)
            self.collectionView.deselectItem(at: end, animated: true)
            self.firstIndexPath = nil
            self.secondIndexPath = nil
            self.wrongImageArray.swapAt(start.item, end.item)
            self.wrongAns.swapAt(start.item, end.item)
            if self.wrongAns == self.correctAns {
                self.dismissPuzzle3Complete()
            }
        }
    }
    
    @objc public func showPuzzle3() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseOut, animations: {
            self.puzzleTitleY?.constant = -200
            self.padlock1Y?.constant = 500
            self.padlock2Y?.constant = 500
            self.padlock3Y?.constant = 500
            self.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.75, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p3TitleY?.constant = 30
            self.p3ExitButtonY?.constant = 0
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.75, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p3InstructionsY?.constant = 25
            self.originalPhotoY?.constant = 25
            self.puzzle3Y?.constant = 0
            self.layoutSubviews()
        }) { (true) in
            return
        }
    }
    
    @objc public func dismissPuzzle3Incomplete() {
        UIView.animate(withDuration: 1.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p3TitleY?.constant = -200
            self.p3ExitButtonY?.constant = -200
            self.p3InstructionsY?.constant = 700
            self.originalPhotoY?.constant = 700
            self.puzzle3Y?.constant = 700
            self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.puzzleTitleY!.constant = 30
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 0.75, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock1Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock2Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 1.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock3Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
    }
    
    @objc public func dismissPuzzle3Complete() {
        UIView.animate(withDuration: 1.75, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.p3TitleY?.constant = -200
            self.p3ExitButtonY?.constant = -200
            self.p3InstructionsY?.constant = 700
            self.originalPhotoY?.constant = 700
            self.puzzle3Y?.constant = 700
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.8, delay: 1.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            self.checkHeight?.constant = 100
            self.checkWidth?.constant = 100
            self.layoutSubviews()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                self.dingSound.play()
            })
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 0.8, delay: 3.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
            self.checkHeight?.constant = 0
            self.checkWidth?.constant = 0
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 3.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 3.25, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.puzzleTitleY!.constant = 30
            self.layoutSubviews()
        }) { (true) in
            return
        }
        UIView.animate(withDuration: 1, delay: 3.50, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock1Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 3.75, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock2Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            return
        }
        
        UIView.animate(withDuration: 1, delay: 4, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.padlock3Y!.constant = 50
            self.layoutSubviews()
        }) { (true) in
            self.padlock3.lock()
            self.closingAnimation()
        }
        
    }

    public func closingAnimation() {
        if self.padlock1.isUserInteractionEnabled == false && self.padlock2.isUserInteractionEnabled == false && self.padlock3.isUserInteractionEnabled == false {
        UIView.animate(withDuration: 1.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseOut, animations: {
            self.puzzleTitleY?.constant = -200
            self.padlock1Y?.constant = 500
            self.padlock2Y?.constant = 500
            self.padlock3Y?.constant = 500
            self.layoutSubviews()
        }) { (true) in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
                self.iphone.alpha = 1
                self.closingMessage.alpha = 1
                self.closingImage.alpha = 1
                self.closingPadlock.alpha = 1
                self.name.alpha = 1
            }) { (true) in
                self.closingPadlock.lock()
            }
        }
        }
    }
    
}
