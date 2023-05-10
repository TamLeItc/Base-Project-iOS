//
//  AlertVC.swift
//  BaseProject
//
//  Created by Tam Le on 02/09/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit
import RxSwift

class AlertVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    @IBOutlet weak var alertInputView: UIView!
    @IBOutlet weak var alertInputTextField: ITextField!
    @IBOutlet weak var alertActionStackView: UIStackView!
    
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var sheetTitleLabel: UILabel!
    @IBOutlet weak var sheetDescriptionLabel: UILabel!
    @IBOutlet weak var sheetActionView: UIView!
    
    @IBOutlet weak var alertInputViewHC: NSLayoutConstraint!
    @IBOutlet weak var sheetActionViewHC: NSLayoutConstraint!
    
    var titleDialog: String = ""
    var messageDialog: String = ""
    var styleDialog: AlertStyle = .alert
    
    var titleColor: UIColor?
    var titleFont: UIFont?
    var messageColor: UIColor?
    var messageFont: UIFont?
    
    var showInputView = false
    var enableEmptyInput = false
    var inputText = ""
    
    private var bag = DisposeBag()
    
    private let heightSheetActionButton: CGFloat = 50
    private var listAlertAction: [AlertAction] = []
    
    private var onClick: ((String) -> Void)? = nil
    
    init(title: String, message: String, style: AlertStyle) {
        super.init(nibName: nil, bundle: nil)
        titleDialog = title
        messageDialog = message
        styleDialog = style
        
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if styleDialog == .actionSheet {
            sheetView.isHidden = false
        } else {
            alertView.isHidden = false
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.sheetView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alertView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.contentView.alpha = 1
        })
    }
    
    func addAction(_ action: AlertAction) {
        if styleDialog == .alert && listAlertAction.count == 3 {
            fatalError("Alert style just only have 2 buttons")
        } else {
            listAlertAction.append(action)
        }
    }
    
    private func setupViews() {
        contentView.alpha = 0
        
        alertView.isHidden = true
        sheetView.isHidden = true
        alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        sheetView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        alertTitleLabel.text = titleDialog
        sheetTitleLabel.text = titleDialog
        alertDescriptionLabel.text = messageDialog
        sheetDescriptionLabel.text = messageDialog
        
        alertView.backgroundColor = AlertTheme.Colors.backgroundColor
        sheetView.backgroundColor = AlertTheme.Colors.backgroundColor
        
        alertTitleLabel.textColor = titleColor == nil ? AlertTheme.Colors.titleColor : titleColor
        alertDescriptionLabel.textColor = messageColor == nil ? AlertTheme.Colors.messageColor : messageColor
        alertTitleLabel.font = titleFont == nil ? AlertTheme.Fonts.alertTitle : titleFont
        alertDescriptionLabel.font = messageFont == nil ? AlertTheme.Fonts.alertMessage : messageFont
        
        sheetTitleLabel.textColor = titleColor == nil ? AlertTheme.Colors.titleColor : titleColor
        sheetDescriptionLabel.textColor = messageColor == nil ? AlertTheme.Colors.messageColor : messageColor
        sheetTitleLabel.font = titleFont == nil ? AlertTheme.Fonts.sheetTitle : titleFont
        sheetDescriptionLabel.font = messageFont == nil ? AlertTheme.Fonts.sheetMessage : messageFont
        
        if styleDialog == .actionSheet {
            sheetActionViewHC.constant = heightSheetActionButton * CGFloat(listAlertAction.count)
        } else {
            alertInputView.isHidden = !showInputView
            if !showInputView {
                alertInputViewHC.constant = 0
            } else {
                alertInputTextField.becomeFirstResponder()
            }
        }
        createAction()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func createAction() {
        var topView: UIView = sheetActionView
        for action in listAlertAction {
            let actionView = createActionButton(action: action)
            if styleDialog == .actionSheet {
                actionView.translatesAutoresizingMaskIntoConstraints = false
                if topView == sheetActionView {
                    actionView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
                } else {
                    actionView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
                }
                NSLayoutConstraint.activate([
                    actionView.leadingAnchor.constraint(equalTo: sheetActionView.leadingAnchor),
                    actionView.trailingAnchor.constraint(equalTo: sheetActionView.trailingAnchor),
                    actionView.heightAnchor.constraint(equalToConstant: heightSheetActionButton)
                ])
            }
            topView = actionView
        }
        if styleDialog == .actionSheet {
            topView.bottomAnchor.constraint(equalTo: sheetActionView.bottomAnchor).isActive = true
        }
    }
    
    private func createActionButton(action: AlertAction) -> UIView {
        let parentView = GradientView()
        if styleDialog == .alert {
            alertActionStackView.addArrangedSubview(parentView)
            parentView.cornerRadius = alertActionStackView.frame.height / 2
        } else {
            sheetActionView.addSubview(parentView)
            parentView.borders(for: [.top], width: 0.5, color: AlertTheme.Colors.Sheet.separatorColor)
        }
        let button = UIButton()
        parentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            button.topAnchor.constraint(equalTo: parentView.topAnchor),
            button.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        
        parentView.letIt {
            $0.backgroundColor = .clear
            $0.startColor = .clear
            $0.endColor = .clear
            $0.horizontalMode = true
        }
        button.letIt {
            $0.backgroundColor = .clear
            $0.setTitle(action.title, for: .normal)
        }
        if styleDialog == .alert {
            if action.style == .normal {
                parentView.letIt {
                    $0.borderColor = AlertTheme.Colors.Alert.normalBorderColor
                    $0.borderWidth = 1
                }
                button.letIt {
                    $0.setTitleColor(AlertTheme.Colors.Alert.normalTitleColor, for: .normal)
                    $0.setTitleColor(AlertTheme.Colors.Alert.normalTitleColor?.withAlphaComponent(0.4), for: .highlighted)
                    $0.titleLabel?.font = AlertTheme.Fonts.alertAction
                }
            } else if action.style == .cancel {
                parentView.letIt {
                    $0.borderColor = AlertTheme.Colors.Alert.normalBorderColor
                    $0.borderWidth = 1
                }
                button.letIt {
                    $0.setTitleColor(AlertTheme.Colors.Alert.normalTitleColor, for: .normal)
                    $0.setTitleColor(AlertTheme.Colors.Alert.normalTitleColor?.withAlphaComponent(0.4), for: .highlighted)
                    $0.titleLabel?.font = AlertTheme.Fonts.alertActionCancel
                }
            } else if action.style == .destructive {
                parentView.letIt {
                    $0.borderColor = AlertTheme.Colors.Alert.destructiveBorderColor
                    $0.borderWidth = 1
                }
                button.letIt {
                    $0.setTitleColor(AlertTheme.Colors.Alert.destructiveBorderColor, for: .normal)
                    $0.setTitleColor(AlertTheme.Colors.Alert.destructiveBorderColor?.withAlphaComponent(0.4), for: .highlighted)
                    $0.titleLabel?.font = AlertTheme.Fonts.alertAction
                }
            }
            else if action.style == .confirm {
                parentView.letIt {
                    $0.startColor = AlertTheme.Colors.Alert.confirmBgStartColor ?? .clear
                    $0.endColor = AlertTheme.Colors.Alert.confirmBgEndColor ?? .clear
                    $0.borderColor = .clear
                    $0.borderWidth = 0
                }
                button.letIt {
                    $0.setTitleColor(AlertTheme.Colors.Alert.confirmTitleColor, for: .normal)
                    $0.setTitleColor(AlertTheme.Colors.Alert.confirmTitleColor?.withAlphaComponent(0.4), for: .highlighted)
                    $0.titleLabel?.font = AlertTheme.Fonts.alertAction
                }
            }
        } else {
            if action.style == .normal || action.style == .confirm {
                button.letIt {
                    $0.setTitleColor(AlertTheme.Colors.Sheet.normalTitleColor, for: .normal)
                    $0.setTitleColor(AlertTheme.Colors.Sheet.normalTitleColor?.withAlphaComponent(0.4), for: .highlighted)
                    $0.titleLabel?.font = AlertTheme.Fonts.sheetAction
                }
            } else if action.style == .destructive {
                button.letIt {
                    $0.setTitleColor(AlertTheme.Colors.Sheet.destructiveTitleColor, for: .normal)
                    $0.setTitleColor(AlertTheme.Colors.Sheet.destructiveTitleColor?.withAlphaComponent(0.4), for: .highlighted)
                    $0.titleLabel?.font = AlertTheme.Fonts.sheetAction
                }
            }
            else {
                button.letIt {
                    $0.setTitleColor(AlertTheme.Colors.Sheet.normalTitleColor, for: .normal)
                    $0.setTitleColor(AlertTheme.Colors.Sheet.normalTitleColor?.withAlphaComponent(0.4), for: .highlighted)
                    $0.titleLabel?.font = AlertTheme.Fonts.sheetActionCancel
                }
            }
        }
        setupEventActionButton(button, action: action)
        
        return parentView
    }
    
    private func setupEventActionButton(_ button: UIButton, action: AlertAction) {
        button.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                if self.showInputView
                    && !self.enableEmptyInput
                    && (self.alertInputTextField.text ?? "").isEmpty {
                    return
                }
                self.onClick = action.onClick
                self.handleDismiss()
            }).disposed(by: bag)
    }

    private func handleDismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.sheetView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.contentView.alpha = 0
            self.alertInputTextField.resignFirstResponder()
        }, completion: {_ in
            self.dismiss(animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self.onClick?(self.alertInputTextField.text ?? "")
            })
        })
    }
    
    deinit {
        print("deinit :: >>>> \(String(describing: self)) <<<<")
    }
}

extension AlertVC {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension AlertVC {
    static func showMessage(_ rootVC: UIViewController, message: AlertMessage) {
        showMessage(rootVC, style: message.type, message: message.description)
    }
    
    static func showMessage(_ rootVC: UIViewController, title: String? = nil, style: AlertMessageType? = nil,  message: String, onClick: (() -> Void)? = nil) {
        
        if title == nil && style == nil {
            fatalError("Title can't nil")
        } else if title != nil && style != nil {
            fatalError("Title or style, not both")
        }
        
        var title = title
        if style == .warning {
            title = "warning".localized
        } else if style == .info {
            title = "infomation".localized
        } else if style == .error {
            title = "error".localized
        }
        let alert = AlertVC(title: title!, message: message, style: .actionSheet)
        if style == .error {
            alert.titleColor = UIColor(hex: 0xFF8080)
        } else if style == .warning {
            alert.titleColor = UIColor(hex: 0xEBA126)
        } else {
            alert.titleColor = UIColor(hex: 0x5AB39D)
        }
        alert.titleFont = UIFont(name: "Poppins-SemiBold", size: 18)
        alert.messageFont = UIFont(name: "Poppins-Regular", size: 14)
        alert.addAction(AlertAction(title: "ok".localized, style: .normal, onClick: {_ in
            onClick?()
        }))
        rootVC.presentVC(alert)
    }
}
