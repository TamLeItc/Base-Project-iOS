//
//  UIImageView.swift
//  BaseProject
//
//  Created by Tam Le on 16/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Kingfisher

extension UIImageView {
    func setImage(with resource: Resource?,
                  placeholder: Placeholder? = #imageLiteral(resourceName: "icon_garden"),
                  onSuccess: (() -> Void)? = nil,
                  onError: (() -> Void)? = nil) {

        kf.indicatorType = .activity
        kf.indicator?.view.borderColor = Theme.Colors.primary
        
        kf.setImage(with: resource,
                    placeholder: placeholder,
                    options: [.transition(.fade(1)),
                              .cacheOriginalImage],
                    completionHandler: { result in
                        switch result {
                        case .success:
                            onSuccess?()
                        case .failure:
                            onError?()
                        }
                    })
    }
}
