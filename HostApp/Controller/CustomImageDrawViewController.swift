
import UIKit
import Foundation
import SwiftUI
import Combine

class CustomImageDrawViewController: UIViewController, ObservableObject {
    
    //MARK: - Vars/Constants
    
    let canvas = Canvas()
    
    var manager = WidgetManager()
        
    var newImg: UIImage!
    
    var didSelectImage: UIImage?
    
    let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleUndo() {
        print("Undo lines drawn")
        
        canvas.undo()
    }
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        return button
    }()
    
    @objc func handleClear() {
        canvas.clear()
        didSelectImage = nil
        
        manager.updateBackgroundImage(didSelectImage)
    }
    
    let applyBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Make The Background", for: .normal)
        button.tintColor = .red
        button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 7.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 19.5)
        button.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
        return button
    }()
    
    @objc func applyAction() {
        
        newImg = generateImageWithText()
        
        didSelectImage = newImg
        
        let imgData = didSelectImage?.pngData()
        
        UserDefaults.standard.set(imgData, forKey: "draw")
        UserDefaults.standard.synchronize()
        
        manager.updateBackgroundImage(didSelectImage)
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.changeBgAlert()
        }
    }
    
    let orangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7.7
        button.backgroundColor = .orange
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let loserColorBtn: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7.7
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let blackButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7.7
        button.backgroundColor = .black
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let greenButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7.7
        button.backgroundColor = .green
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let redButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7.7
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let blueButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7.7
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let yellowButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7.7
        button.backgroundColor = .yellow
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleColorChange(button: UIButton) {
        canvas.setStrokeColor(color: button.backgroundColor ?? .black)
    }
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc fileprivate func handleSliderChange() {
        canvas.setStrokeWidth(width: slider.value)
    }
    
    override func loadView() {
        self.view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        canvas.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Functions
    
    fileprivate func setupLayout() {
        
        let colorsStackView = UIStackView(arrangedSubviews: [orangeButton, blackButton, yellowButton, greenButton, redButton, blueButton])
        
        
        let stackView = UIStackView(arrangedSubviews: [
            undoButton,
            clearButton,
            colorsStackView,
            slider
        ])
        stackView.spacing = 5
        stackView.distribution = .fill
        
        colorsStackView.distribution = .fillProportionally
        
        view.addSubview(applyBtn)
        view.addSubview(stackView)
        applyBtn.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10).isActive = true
        applyBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        
        
    }
    
    func changeBgAlert() {
        // Show alert
        let alert = UIAlertController(title: "Congartulations!!!", message: "The Background image of widget is now your drawing!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
            //self.objectWillChange.send()
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func generateImageWithText() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        newImg = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImg
    }
}

struct CustomViewControllerRepresentation: UIViewControllerRepresentable {
    
    var didSelectImage: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomViewControllerRepresentation>) -> CustomImageDrawViewController {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "drawVC") as! CustomImageDrawViewController
        vc.didSelectImage = self.didSelectImage
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CustomImageDrawViewController, context: UIViewControllerRepresentableContext<CustomViewControllerRepresentation>) {
        
    }
}

struct ViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        
        CustomViewControllerRepresentation()
    }
}
