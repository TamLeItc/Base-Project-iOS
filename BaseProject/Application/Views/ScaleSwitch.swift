//
//  ScaleSwitch.swift
//  i270-locksafe
//
//  Created by Tam Le on 29/03/2023.
//

import UIKit

@IBDesignable class ScaleSwitch: UISwitch {

    @IBInspectable var scale : CGFloat = 0.8 {
        didSet{
            setup()
        }
    }

    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup(){
        transform = CGAffineTransform(scaleX: scale, y: scale)
    }

    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }


}
