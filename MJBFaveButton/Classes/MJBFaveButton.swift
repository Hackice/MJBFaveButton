//
//  MJBFaveButton.swift
//  Meijiabang
//
//  Created by Hackice on 2017/7/14.
//  Copyright © 2017年 MooYoo. All rights reserved.
//

import UIKit

open class MJBFaveButton: UIButton {
    
    fileprivate struct Const {
        static let duration = 1.0
        static let expandDuration = 0.1298
        static let collapseDuration = 0.1089
        static let faveIconShowDelay = Const.expandDuration + Const.collapseDuration / 2.0
        static let dotRadiusFactors = (first: 0.0633, second: 0.04)
        static let sparkGroupCount: Int = 7
    }
    
    open var shouldAnimate: Bool = true
    
    @IBInspectable open var dotFirstColor: UIColor   = UIColor(red: 152/255, green: 219/255, blue: 236/255, alpha: 1)
    @IBInspectable open var dotSecondColor: UIColor  = UIColor(red: 247/255, green: 188/255, blue: 48/255,  alpha: 1)
    @IBInspectable open var circleFromColor: UIColor = UIColor(red: 221/255, green: 70/255,  blue: 136/255, alpha: 1)
    @IBInspectable open var circleToColor: UIColor   = UIColor(red: 205/255, green: 143/255, blue: 246/255, alpha: 1)
    
    override open var isSelected: Bool {
        didSet {
            guard shouldAnimate else { return }
            animateWithSparksAndRings(self, firstColor: dotFirstColor, secondColor: dotSecondColor, circleFromColor: circleFromColor, circleToColor: circleToColor)
        }
    }
    
    open func isSelected(_ selected: Bool, animated: Bool) {
        shouldAnimate = animated
        isSelected = selected
        shouldAnimate = true
    }
    
    fileprivate func animateWithSparksAndRings(_ button: UIButton, duration: Double = 1, firstColor: UIColor, secondColor: UIColor, circleFromColor: UIColor, circleToColor: UIColor) {
        // Zoom Animation
        var view: UIView?
        if (imageView?.image != nil) {
            view = imageView
        } else {
            view = button
        }
        guard let animateView = view else { return }
        let scaleAnimation = Init(CAKeyframeAnimation(keyPath: "transform.scale")) {
            $0.values    = generateTweenValues(from: 0, to: 1.0, duration: CGFloat(duration))
            $0.duration  = duration
            $0.beginTime = CACurrentMediaTime()
        }
        animateView.layer.add(scaleAnimation, forKey: nil)
        
        if isSelected {
            self.alpha = 0
            UIView.animate(
                withDuration: 0,
                delay: 0,
                options: .curveLinear,
                animations: {
                    self.alpha = 1
            }, completion: nil)
        }
        
        guard isSelected else { return }
        // Spark Animation
        let bounds = animateView.bounds
        let radius = bounds.size.scaleBy(1.3).width / 2 // ring radius
        let igniteFromRadius = radius * 0.8
        let igniteToRadius = radius * 1.1
        let ring = Ring.createRing(animateView, radius: 0.01, lineWidth: 3, fillColor: circleFromColor)
        
        func createSparks() -> [Spark] {
            let radius = igniteFromRadius
            var sparks = [Spark]()
            let step = 360.0 / 7.0
            let base = Double(bounds.size.width)
            let dotRadius = (base * Const.dotRadiusFactors.first, base * Const.dotRadiusFactors.second)
            let offset = 10.0
            
            for index in 0..<Const.sparkGroupCount {
                let theta = step * Double(index) + offset
                let spark = Spark.createSpark(animateView, radius: radius, firstColor: firstColor, secondColor: secondColor, angle: theta,
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
    
    private func generateTweenValues(from: CGFloat, to: CGFloat, duration: CGFloat) -> [CGFloat]{
        var values         = [CGFloat]()
        let fps            = CGFloat(60.0)
        let tpf            = duration/fps
        let c              = to-from
        let d              = duration
        var t              = CGFloat(0.0)
        let tweenFunction  = Elastic.ExtendedEaseOut
        
        while(t < d) {
            let scale = tweenFunction(t, from, c, d, c+0.001, 0.39988)  // p=oscillations, c=amplitude(velocity)
            values.append(scale)
            t += tpf
        }
        return values
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
