//
//  DemoBlurAndEffectVC.swift
//  BaseProject
//
//  Created by Tam Le on 17/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit

class DemoBlurVC: BaseVC<BaseVM> {

    @IBOutlet weak var blurImageView: UIImageView!
    @IBOutlet weak var ciFilterNameLabel: UILabel!
    @IBOutlet weak var radiusBlurLabel: UILabel!
    @IBOutlet weak var changeFilterButton: UIButton!
    @IBOutlet weak var increaseRadiusButton: UIButton!
    @IBOutlet weak var decreaseRadiusButton: UIButton!
    
    private var filters: [BlurStyle] = [.ciBoxBlur, .ciDiscBlur,
                                        .ciGaussianBlur, .ciMotionBlur]
    
    private var indextFilter = 0
    private var radiusBlur: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func initViews() {
        super.initViews()
        
        loadBlur()
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        changeFilterButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.indextFilter = self.indextFilter + 1
                if self.indextFilter > self.filters.count - 1 {
                    self.indextFilter = 0
                }
                self.loadBlur()
            }).disposed(by: bag)
        
        decreaseRadiusButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.radiusBlur += 5
                self.loadBlur()
            }).disposed(by: bag)
        
        increaseRadiusButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.radiusBlur -= 5
                self.loadBlur()
            }).disposed(by: bag)
    }
    
    private func loadBlur() {
        ciFilterNameLabel.text = filters[indextFilter].rawValue
        radiusBlurLabel.text = "Radius: \(radiusBlur)"
        
        blurImageView.image = "bg_flower".toUIImage()?.asBlurImage(ciFilterName: filters[indextFilter], radius: radiusBlur)
    }

}
