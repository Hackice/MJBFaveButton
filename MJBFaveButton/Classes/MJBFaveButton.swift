//
//  MJBFaveButton.swift
//  Meijiabang
//
//  Created by 王雁冰 on 2017/7/14.
//  Copyright © 2017年 Double. All rights reserved.
//

import UIKit

open class MJBFaveButton: UIButton {

    fileprivate func color(_ rgbColor: Int) -> UIColor {
        return UIColor(
            red: CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbColor & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat((rgbColor & 0x0000FF) >> 0) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    fileprivate struct Const {
        static let duration = 1.0
        static let expandDuration = 0.1298
        static let collapseDuration = 0.1089
        static let faveIconShowDelay = Const.expandDuration + Const.collapseDuration / 2.0
        static let dotRadiusFactors = (first: 0.0633, second: 0.04)
        static let sparkGroupCount: Int = 7
    }

    open var shouldAnimate: Bool = true

    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                isHighlighted = false
            }
        }
    }

    override open var isSelected: Bool {
        didSet {
            guard shouldAnimate else { return }
            animateWithSparksAndRings(self, firstColor: color(0x7DC2F4), secondColor: color(0xE2264D), circleFromColor: color(0xF8CC61), circleToColor: color(0x9BDFBA))
        }
    }

    open func isSelected(_ selected: Bool, animated: Bool) {
        shouldAnimate = animated
        isSelected = selected
        shouldAnimate = true
    }

    fileprivate func animateWithSparksAndRings(_ button: UIButton, firstColor: UIColor, secondColor: UIColor, circleFromColor: UIColor, circleToColor: UIColor) {
        let bounds = button.bounds
        let radius = bounds.size.scaleBy(1.3).width / 2 // ring radius
        let igniteFromRadius = radius * 0.8
        let igniteToRadius = radius * 1.1
        let ring = Ring.createRing(button, radius: 0.01, lineWidth: 3, fillColor: circleFromColor)

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0.7
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }) { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            }) { _ in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
        }

        guard isSelected else { return }

        func createSparks() -> [Spark] {
            let radius = igniteFromRadius
            var sparks = [Spark]()
            let step = 360.0 / 7.0
            let base = Double(bounds.size.width)
            let dotRadius = (base * Const.dotRadiusFactors.first, base * Const.dotRadiusFactors.second)
            let offset = 10.0

            for index in 0..<Const.sparkGroupCount {
                let theta = step * Double(index) + offset
                let spark = Spark.createSpark(button, radius: radius, firstColor: firstColor, secondColor: secondColor, angle: theta,
                                              dotRadius: dotRadius)
                sparks.append(spark)
            }
            return sparks
        }
        let sparks = createSparks()

        ring.animateToRadius(radius, toColor: circleToColor, duration: Const.expandDuration, delay: 0)
        ring.animateColapse(radius, duration: Const.collapseDuration, delay: Const.expandDuration)

        sparks.forEach {
            $0.animateIgniteShow(igniteToRadius, duration: 0.4, delay: Const.collapseDuration / 3.0)
            $0.animateIgniteHide(0.7, delay: 0.2)
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
