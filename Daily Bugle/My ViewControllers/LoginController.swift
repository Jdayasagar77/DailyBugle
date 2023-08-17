//
//  LoginController.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 30/11/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore



class LoginController: UIViewController {

    @IBOutlet weak var loginLogo: UIImageView!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    var userMailDelegate: CurrentUser?
    @IBAction func logInAction(_ sender: UIButton)
    {
        if ((userNameTxtField.text?.isEmpty) == nil || userNameTxtField.text?.isValidEmail() == false)
        {
            showMessage(title: "Enter a Valid Mail")
            debugPrint("User Entered Invalid Mail While Logging")
        }
        else if passwordTxtField.text?.utf8CString.count ?? 0 <= 5
        {
            showMessage(title: "Password Must be more than 5 characters")
            debugPrint("User Entered Less Number of Characters in Password while Logging")
        }
        else if ((userNameTxtField.text?.isValidEmail()) == true)
        {
            passwordTxtField.isSecureTextEntry = true
            Auth.auth().signIn(withEmail: userNameTxtField.text!, password: passwordTxtField.text!) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
                if let user = authResult?.user {
                    strongSelf.dismiss(animated: true)
                    self?.userMailDelegate?.activeUser(user.email!)
                    debugPrint("User \(user.email as Any) Has Logged In from Firebase")
                                               let myVC = MainVC.init(nibName: "MainVC", bundle: nil)
                                               let myNav = UINavigationController.init(rootViewController: myVC)
                                               myNav.modalTransitionStyle = .crossDissolve
                                               myNav.modalPresentationStyle = .fullScreen
                    strongSelf.present(myNav, animated: true)
                }
                else
                {
                    strongSelf.showMessage(title: "Email or Password is Incorrect")
                    debugPrint("User Entered Wrong Password or Mail While Logging")
                }
            }
                    debugPrint("Signed in as \(String(describing:  Auth.auth().currentUser?.email)) using Firebase Authentication")
        }
//        else
//            {
//            showMessage(title: "This User Does Not Exist, Please Sign Up")
//            debugPrint("User Entered Mail Which Do Not Exist While Logging")
//            }
    }//Log In Action ends here
    

    let circle1 = CAShapeLayer()
    let circle2 = CAShapeLayer()
    let circle3 = CAShapeLayer()
    let circle4 = CAShapeLayer()
    let circle5 = CAShapeLayer()
    let circle6 = CAShapeLayer()
    let cirlePath1 = UIBezierPath(arcCenter: CGPoint(x: 50, y: 250), radius: 100, startAngle: 2*CGFloat.pi, endAngle: 0, clockwise: false)
    let cirlePath2 = UIBezierPath(arcCenter: CGPoint(x: 100, y: 500), radius: 50, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
    let cirlePath3 = UIBezierPath(arcCenter: CGPoint(x: 200, y: 750), radius: 50, startAngle: 2*CGFloat.pi, endAngle: 0, clockwise: false)
    let cirlePath4 = UIBezierPath(arcCenter: CGPoint(x: 150, y: 0), radius: 75, startAngle: 2*CGFloat.pi, endAngle: 0, clockwise: false)
    let cirlePath5 = UIBezierPath(arcCenter: CGPoint(x: 0, y: 100), radius: 75, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
    let cirlePath6 = UIBezierPath(arcCenter: CGPoint(x: 250, y: 50), radius: 60, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
    
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        let myVC = SignUpVC.init(nibName: "SignUpVC", bundle: nil)
        let myNav = UINavigationController.init(rootViewController: myVC)
        myNav.modalTransitionStyle = .coverVertical
        present(myNav, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
     self.loginLogo.image = UIImage(named: "bugle2")
        self.loginLogo.layer.cornerRadius = self.loginLogo.frame.size.width / 2
        self.loginLogo.clipsToBounds = true
    }
    

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.animateMovement(myCircle: self.circle1, myPath: self.cirlePath1, myPostion1: CGPoint(x: 300, y: 60), myPostion2: CGPoint(x: 0, y: 650), myColor: UIColor.green, myOpacity: 0.5, myTransformation: 0.9, myTime: 3)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.animateMovement(myCircle: self.circle2, myPath: self.cirlePath2, myPostion1: CGPoint(x: 100, y: 250), myPostion2: CGPoint(x: 350, y: 50), myColor: UIColor.blue, myOpacity: 0.8, myTransformation: 0.6, myTime: 2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.animateMovement(myCircle: self.circle3, myPath: self.cirlePath3, myPostion1: CGPoint(x: 250, y: 175), myPostion2: CGPoint(x: 75, y: 0), myColor: UIColor.lightGray, myOpacity: 0.6, myTransformation: 0.8, myTime: 4)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.animateMovement(myCircle: self.circle4, myPath: self.cirlePath4, myPostion1: CGPoint(x: 200, y: 0), myPostion2: CGPoint(x: 190, y: 550), myColor: UIColor.cyan, myOpacity: 0.4, myTransformation: 0.9, myTime: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.animateMovement(myCircle: self.circle5, myPath: self.cirlePath5, myPostion1: CGPoint(x: 150, y: 500), myPostion2: CGPoint(x: 300, y: 150), myColor: UIColor.yellow, myOpacity: 0.2, myTransformation: 0.8, myTime: 3)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.animateMovement(myCircle: self.circle6, myPath: self.cirlePath6, myPostion1: CGPoint(x: 25, y: 150), myPostion2: CGPoint(x: 130, y: 450), myColor: UIColor.red, myOpacity: 0.2, myTransformation: 0.7, myTime: 2)
        }
        view.layer.addSublayer(circle1)
        view.layer.addSublayer(circle2)
        view.layer.addSublayer(circle3)
        view.layer.addSublayer(circle4)
        view.layer.addSublayer(circle5)
        view.layer.addSublayer(circle6)
       // fadeInOutA()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTxtField.isSecureTextEntry = true
        self.passwordTxtField.delegate = self
        self.userNameTxtField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.setupToHideKeyboardOnTapOnView()

    }

 
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func animateMovement(myCircle: CAShapeLayer, myPath: UIBezierPath, myPostion1: CGPoint, myPostion2: CGPoint, myColor: UIColor, myOpacity: Double, myTransformation: Double, myTime: Double)
    {
        myCircle.path  = myPath.cgPath
        myCircle.fillColor = myColor.cgColor
    let animation = CABasicAnimation(keyPath: "position")
//        animation.fromValue = CGPoint(x: circle1.frame.origin.x + (circle1.frame.size.width/2), y: circle1.frame.origin.y + (circle1.frame.size.height/2))
        animation.fromValue = myPostion2
        animation.toValue = myPostion1
        animation.duration = myTime
//        animation.timingFunction = CAMediaTimingFunction(name: <#T##CAMediaTimingFunctionName#>)
        animation.fillMode = .forwards
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        animation.beginTime = CACurrentMediaTime()
        animation.repeatCount = .greatestFiniteMagnitude
        myCircle.add(animation, forKey: nil)
    let animation1 = CABasicAnimation(keyPath: "opacity")
        animation1.fromValue = 0.0
        animation1.toValue = myOpacity
        animation1.duration = 4.0
        animation1.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation1.autoreverses = true
        animation1.repeatCount = .greatestFiniteMagnitude
        myCircle.add(animation1, forKey: nil)
    let animation2 = CABasicAnimation(keyPath: "transform.scale")
        animation2.fromValue = 0
        animation2.toValue = myTransformation
        animation2.duration = 3
        animation2.autoreverses = true
        animation2.repeatCount = .greatestFiniteMagnitude
        myCircle.add(animation2, forKey: nil)
    }
}

