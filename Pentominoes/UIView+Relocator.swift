//
//  UIView+Relocator.swift
//  Pentominoes
//
//  Created by Richard Turton on 29/07/2016.
//  Copyright © 2016 Richard Turton. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewPreservingLocation(_ view: UIView) {
        let centerInSelf = self.convert(view.center, from: view.superview)
        self.addSubview(view)
        view.center = centerInSelf
    }
}
