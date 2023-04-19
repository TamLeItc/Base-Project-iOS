//
//  DemoHomeVC.swift
//  BaseProject
//
//  Created by Tam Le on 16/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit

class DemoHomeVC: BaseVC<DemoHomeVM> {

    @IBOutlet weak var demoLoadDataAndBottomSheetButton: UIButton!
    @IBOutlet weak var demoBlurImage: UIButton!
    @IBOutlet weak var demoActionSheetDialog: UIButton!
    @IBOutlet weak var demoAlertDialog: UIButton!
    @IBOutlet weak var demoInputAlertDialog: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enablePopGestureRecognizer = false
    }

    override func addEventForViews() {
        super.addEventForViews()
        
        demoLoadDataAndBottomSheetButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.pushVC(DemoLoadDataVC())
            }).disposed(by: bag)
        
        demoBlurImage.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.pushVC(DemoBlurVC())
            }).disposed(by: bag)
        
        demoActionSheetDialog.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                let alert = AlertVC(title: "Demo Action Sheet", message: "Please select action", style: .actionSheet)
                alert.addAction(AlertAction(title: "Save", style: .normal, onClick: {_ in
                    self.showToast(message: "Save selected")
                }))
                alert.addAction(AlertAction(title: "Delete", style: .destructive, onClick: {_ in
                    self.showToast(message: "delete selected")
                }))
                alert.addAction(AlertAction(title: "Cancel", style: .cancel, onClick: {_ in 
                    self.showToast(message: "Cancel selected")
                }))
                self.presentVC(alert)
            }).disposed(by: bag)
        
        demoAlertDialog.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                let alert = AlertVC(title: "Warning", message: "Are you sure you want to cancel editing?", style: .alert)
                alert.addAction(AlertAction(title: "Cancel", style: .cancel, onClick: {_ in 
                    self.showToast(message: "cancel selected")
                }))
                alert.addAction(AlertAction(title: "OK", style: .destructive, onClick: {_ in
                    self.showToast(message: "ok selected")
                }))
                self.presentVC(alert)
            }).disposed(by: bag)
        
        demoInputAlertDialog.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                let alert = AlertVC(title: "Rename file", message: "Please input your name file", style: .alert)
                alert.addAction(AlertAction(title: "Cancel", style: .cancel, onClick: {_ in 
                    self.showToast(message: "cancel selected")
                }))
                alert.addAction(AlertAction(title: "OK", style: .confirm, onClick: { text in
                    self.showToast(message: text)
                }))
                alert.showInputView = true
                self.presentVC(alert)
            }).disposed(by: bag)
    }

}
