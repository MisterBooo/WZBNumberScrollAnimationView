//
//  WZBNumberScrollAnimationView.swift
//  WZBNumberScrollAnimationView
//
//  Created by Zeno on 2017/4/22.
//  Copyright © 2017年 吴至波. All rights reserved.
//

import UIKit

private let WZBNumberScrollAnimationViewKey = "WZBNumberScrollAnimationViewKey"

class WZBNumberScrollAnimationView: UIView {

    var number : NSString? {
        didSet{
            prepareAnimations()
        }
    }
    
    var textColor : UIColor = .black
    
    var font : UIFont = UIFont.systemFont(ofSize: 22.0)
    
    var density : NSInteger = 5
    
    var minLength : NSInteger = 0
    
    var duration : TimeInterval = 1.5
    
    var durationOffset : TimeInterval = 0.2
    
    var isAscending : Bool = false
    

    
    fileprivate lazy var numbersText : NSMutableArray = NSMutableArray()
    
    fileprivate lazy var scrollLayers : NSMutableArray = NSMutableArray()
    
    fileprivate lazy var scrollLabels : NSMutableArray = NSMutableArray()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
  
    

}

extension WZBNumberScrollAnimationView {
    func reloadView(){
        prepareAnimations()
    }
    
    func startAnimation(){
        createAnimations()
    }
    
    func stopAnimation(){
        for (_,layer) in scrollLayers.enumerated() {
            (layer as! CALayer).removeAnimation(forKey: WZBNumberScrollAnimationViewKey)
        }
    }
}

extension WZBNumberScrollAnimationView {
    fileprivate func commonInit(){
        
    }
    fileprivate func prepareAnimations(){
        print("prepareAnimations:\(String(describing: number))")
        
        for layer in scrollLayers{
            (layer as! CALayer).removeFromSuperlayer()
        }
        
        numbersText.removeAllObjects()
        scrollLayers.removeAllObjects()
        scrollLabels.removeAllObjects()
        
        configNumbersText()
        configScrollLayers()
    }
    
    fileprivate func configNumbersText(){
      
       
        
        guard (number?.length)! >= minLength else {
            for i in 0..<(number?.length)!{
                numbersText.add(number?.substring(with: NSMakeRange(i, 1)) ?? "0")
            }
            return
        }
        for _ in 0..<( (number?.length)! - minLength ){
            numbersText.add("0")
        }
        for i in 0..<(number?.length)!{
          numbersText.add(number?.substring(with: NSMakeRange(i, 1)) ?? "0")
        }
       
    }
    
    fileprivate func configScrollLayers(){
        
        let width = self.frame.size.width / CGFloat(numbersText.count)
        let height = self.frame.size.height
        for i in 0..<numbersText.count {
            let layer = CAScrollLayer()
            layer.frame =  CGRect(x: (CGFloat(i) * width), y: 0, width: width, height: height)
            scrollLayers.add(layer)
            self.layer.addSublayer(layer)
            let numberText = numbersText[i]
            configScrollLayer(layer: layer, numberText: numberText as! NSString)
        }
        
        
    }
    fileprivate func configScrollLayer( layer: CAScrollLayer, numberText: NSString){
        let scrollNumbers = NSMutableArray()
        let number = Int ( numberText as String)
        for i in 0..<density + 1 {
            scrollNumbers.add(String((number! + i) % 10))
        }
        scrollNumbers.add(numberText)
        
        var  height : CGFloat = 0
        for (_,text) in scrollNumbers.enumerated() {
            let label = createLabel(text: text as! String)
            label.frame = CGRect(x: 0, y: height, width: layer.frame.size.width, height: layer.frame.size.height)
            layer.addSublayer(label.layer)
            scrollLabels.add(label)
            height = label.frame.maxY
        }
       
    }
    
    fileprivate func createLabel(text: String) ->(UILabel ){
        let label = UILabel()
        label.textColor = textColor;
        label.font = font
        label.textAlignment = .center
        label.text = text
        return label
    }
    
}

extension WZBNumberScrollAnimationView {
    fileprivate func createAnimations(){
        var duration = self.duration - Double(numbersText.count - 1)*durationOffset
        for layer in scrollLayers {
          let maxY  =  (layer as! CALayer).sublayers?.last?.frame.origin.y
            
          let animation = CABasicAnimation(keyPath:"sublayerTransform.translation.y" )
          animation.duration = duration
          animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            if isAscending {
                animation.fromValue = 0
                animation.toValue = -maxY!
            }else{
                animation.fromValue = -maxY!
                animation.toValue = 0
            }
            (layer as! CALayer).add(animation, forKey: WZBNumberScrollAnimationViewKey)
            duration += durationOffset
        }
        
    }
}






