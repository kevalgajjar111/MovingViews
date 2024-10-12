//
//  ViewController.swift
//  MovingViews
//
//  Created by Keval Gajjar on 10/10/24.
//

import UIKit

private struct Titles {
    // Button's Titles
    static let addButton = "Add"
    static let topButton = "Top"
    static let bottomButton = "Bottom"
    static let leftButton = "Left"
    static let rightBuutton = "Right"
    static let centerVerticalButton = "Center V"
    static let centerHorizontalButton = "Center H"
    static let orderButton = "Order"
    
    // Other Common Texts
    static let editTitleTxt = "Edit me"
}


// Constants
private let textFieldsCommonHeight: CGFloat = 50.0
private let commonFontSize = UIFont.systemFont(ofSize: 13)
private let commonSelectedFontSize = UIFont.boldSystemFont(ofSize: 15)


final class HomeView: UIViewController {
    
    // MARK: - View's Objects
    // Canvas where views will be added
    fileprivate let canvasView = UIView()
    fileprivate var textFieldWidthConstraints = [UITextField: NSLayoutConstraint]()

    // Buttons for control
    fileprivate let addButton = UIButton()
    fileprivate let topButton = UIButton()
    fileprivate let bottomButton = UIButton()
    fileprivate let leftButton = UIButton()
    fileprivate let rightButton = UIButton()
    fileprivate let centerVButton = UIButton()
    fileprivate let centerHButton = UIButton()
    fileprivate let orderButton = UIButton()
    
    // Currently selected view
    var selectedView: UIView?
    
    // MARK: - View Controller's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvas()
        setupButtons()
    }
    
    // MARK: - Class Helpers
    fileprivate func setupCanvas() {
        canvasView.backgroundColor = .white
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvasView)
        
        // Constraints for canvas
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    fileprivate func setupButtons() {
        // Create and add buttons to the bottom of the screen
        let buttonTitles = [Titles.addButton,
                            Titles.topButton,
                            Titles.bottomButton,
                            Titles.leftButton,
                            Titles.rightBuutton,
                            Titles.centerVerticalButton,
                            Titles.centerHorizontalButton,
                            Titles.orderButton
        ]

        let buttons = [addButton, 
                       topButton,
                       bottomButton,
                       leftButton,
                       rightButton,
                       centerVButton,
                       centerHButton,
                       orderButton
        ]
        
        let buttonStackView = UIStackView(arrangedSubviews: buttons)
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: textFieldsCommonHeight)
        ])
        
        // Set button titles and actions
        for (index, button) in buttons.enumerated() {
            button.setTitle(buttonTitles[index], for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = commonFontSize
            button.backgroundColor = .darkGray
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
    }
    
    fileprivate func orderViews() {
        // Spacing between the views
        let padding: CGFloat = 10
        
        // Starting x and y positions for the first view
        var currentX: CGFloat = padding
        var currentY: CGFloat = padding
        
        // Loop through all subviews in the canvas
        for subview in canvasView.subviews {
            let subviewWidth = subview.frame.width
            let subviewHeight = subview.frame.height
            
            // Check if the view can fit horizontally in the current row
            if currentX + subviewWidth + padding > canvasView.frame.width {
                // Move to the next row if it doesn't fit
                currentX = padding
                currentY += subviewHeight + padding
            }
            subview.frame.origin = CGPoint(x: currentX, y: currentY)
            currentX += subviewWidth + padding
            if currentY + subviewHeight > canvasView.frame.height {
                break
            }
        }
    }
    
    // MARK: - Actions
    @objc func buttonTapped(_ sender: UIButton) {
        
        
        _ = [addButton,
         topButton,
         bottomButton,
         leftButton,
         rightButton,
         centerVButton,
         centerHButton,
         orderButton
        ].compactMap{ $0.titleLabel?.font = commonFontSize } // Reset fonts to normal for all the buttons
        sender.titleLabel?.font = commonSelectedFontSize // Set selected font's for the selected button
        
        switch sender {
        case addButton:
            addTextField()
        case topButton:
            alignSelectedView(to: .top)
        case bottomButton:
            alignSelectedView(to: .bottom)
        case leftButton:
            alignSelectedView(to: .left)
        case rightButton:
            alignSelectedView(to: .right)
        case centerVButton:
            alignSelectedView(to: .centerV)
        case centerHButton:
            alignSelectedView(to: .centerH)
        case orderButton:
            orderViews()
        default:
            break
        }
    }
    
    
    
}

extension HomeView: UITextFieldDelegate {
    
    enum Alignment {
        case top, 
             bottom,
             left,
             right,
             centerV,
             centerH
    }
    
    fileprivate func addTextField() {
        let textField = UITextField()
        textField.backgroundColor = randomColor()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.text = Titles.editTitleTxt
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self  // Set delegate to self
        canvasView.addSubview(textField)
        
        // Create width and height constraints for the text field
        let widthConstraint = textField.widthAnchor.constraint(equalToConstant: 150)
        let heightConstraint = textField.heightAnchor.constraint(equalToConstant: 40)
        
        // Center the textField in the canvas
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor),
            widthConstraint,
            heightConstraint
        ])

       
        // Add tap gesture to select the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectView(_:)))
        textField.addGestureRecognizer(tapGesture)
        textField.isUserInteractionEnabled = true
        
        // Add target for text change to dynamically adjust width
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Enable pan gesture for dragging the text field
        self.enablePanGesture(for: textField)
        
        // Store the width constraint for dynamic adjustment
        textFieldWidthConstraints[textField] = widthConstraint

        
    }
    
    fileprivate  func alignSelectedView(to alignment: Alignment) {
        guard let view = selectedView else { return }
        
        switch alignment {
        case .top:
            view.frame.origin.y = 0
        case .bottom:
            view.frame.origin.y = canvasView.frame.height - view.frame.height
        case .left:
            view.frame.origin.x = 0
        case .right:
            view.frame.origin.x = canvasView.frame.width - view.frame.width
        case .centerV:
            view.center.y = canvasView.frame.height / 2
        case .centerH:
            view.center.x = canvasView.frame.width / 2
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func selectView(_ gesture: UITapGestureRecognizer) {
        if let selected = selectedView {
            // Remove blue border from previous selection
            selected.layer.borderWidth = 0
        }
        
        if let tappedView = gesture.view {
            selectedView = tappedView
            selectedView?.layer.borderWidth = 2
            selectedView?.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let textFieldWidthConstraint = textFieldWidthConstraints[textField] else { return }
        
        // Calculate the new width based on the text content
        let size = (textField.text! as NSString).size(withAttributes: [.font: textField.font ?? UIFont.systemFont(ofSize: 17)])
        
        // Add some padding around the text
        var newWidth = max(size.width + 20, 50) // Set a minimum width of 50
        if newWidth > self.view.frame.size.width {
            newWidth = self.view.frame.size.width - 40
        }
        // Update the width constraint
        textFieldWidthConstraint.constant = newWidth
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
    // Method to generate a random color
    fileprivate  func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
}

extension HomeView {
    
    fileprivate func enablePanGesture(for view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = selectedView else { return }
        
        let translation = gesture.translation(in: canvasView)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: canvasView)
        
        // Ensure the view doesn't go outside the canvas bounds
        let maxX = canvasView.frame.width - view.frame.width / 2
        let maxY = canvasView.frame.height - view.frame.height / 2
        let minX = view.frame.width / 2
        let minY = view.frame.height / 2
        
        if view.center.x > maxX {
            view.center.x = maxX
        } else if view.center.x < minX {
            view.center.x = minX
        }
        
        if view.center.y > maxY {
            view.center.y = maxY
        } else if view.center.y < minY {
            view.center.y = minY
        }
    }
}
