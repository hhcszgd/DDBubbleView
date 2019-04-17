//
//  DDBubbleView.swift
//  Project
//
//  Created by WY on 2019/4/16.
//  Copyright © 2019 HHCSZGD. All rights reserved.
//

import UIKit
enum  DDEdgeDirection {
    case top
    case left
    case bottom
    case right
}
extension UIView{
//    func showBubble<T:DDBubbleDelegate>(buttleView:T) where T : UIView   {
//        self.superview?.addSubview(buttleView)
//        buttleView.brotherView = self
//    }
}
protocol DDBubbleDelegate {
    var lengthRate : CGFloat {get set }
    ///箭头指向挂靠视图的位置
    var brotherLengthRate : CGFloat{get set }
    var brotherView : UIView{get set}
    var direction : DDEdgeDirection {get set }
    
}
class DDBubbleView: UIView  , DDBubbleDelegate{
    //0 ~ 1
    var lengthRate : CGFloat = 0.5
    ///箭头指向挂靠视图的位置
    var brotherLengthRate : CGFloat = 0.5
    ///所指向的视图的位置
    var direction : DDEdgeDirection = .top
    var brotherView : UIView = UIView()
    private var arrowImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
    private let radiuscornerView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(radiuscornerView)
        radiuscornerView.backgroundColor = UIColor.white
//        arrowImageView.backgroundColor = .orange
        arrowImageView.image = UIImage(named:"pulldownarrowhead")
        self.addSubview(arrowImageView)
    }
    static func removeFrom(brotherView:UIView){
        for subview in brotherView.superview?.subviews ?? []{
            if subview.isKind(of: DDBubbleView.self) {
                subview.removeFromSuperview()
            }
        }
        for subview in brotherView.subviews{
            if subview.isKind(of: DDBubbleView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    static func show(_ brotherView:UIView , _ brotherLengthRate:CGFloat,_ lengthRate:CGFloat,_ direction:DDEdgeDirection , layoutHandler:((DDBubbleView)->(CGSize))?){
        let b = DDBubbleView()
        b.brotherView = brotherView
        b.brotherLengthRate = brotherLengthRate
        b.lengthRate = lengthRate
        b.direction = direction
        brotherView.superview?.addSubview(b)
        b.bounds = CGRect(origin: CGPoint.zero, size: layoutHandler?(b) ?? CGSize.zero)
        if b.subviews.count >= 3 {
            let firstView = b.subviews[2]
            let firstSubviewWidth = firstView.bounds.width
            let firstSubviewHeight = firstView.bounds.height
            if b.bounds.width <= firstSubviewWidth + 5 {
                b.frame.size.width = firstSubviewWidth + 20
                firstView.frame.origin.x += 10
            }
            if b.bounds.height <= firstSubviewHeight + 5{
                b.frame.size.height = firstSubviewHeight + 20
                firstView.frame.origin.y += 10
            }
        }
        
        b.layoutIfNeeded()
        b.setNeedsLayout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var pinBrothViewX = self.brotherView.bounds.width * self.brotherLengthRate
        if pinBrothViewX > self.brotherView.bounds.width - arrowImageView.bounds.width/2{
            pinBrothViewX = self.brotherView.bounds.width - arrowImageView.bounds.width/2
        }else if pinBrothViewX < arrowImageView.bounds.width/2{
            pinBrothViewX = arrowImageView.bounds.width/2
        }
        
        var pinBrothViewY = self.brotherView.bounds.height * self.brotherLengthRate
        if pinBrothViewY > self.brotherView.bounds.height - arrowImageView.bounds.height/2 {
            pinBrothViewY = self.brotherView.bounds.height - arrowImageView.bounds.height/2
        }else if pinBrothViewY < arrowImageView.bounds.height/2 {
            pinBrothViewY = arrowImageView.bounds.height/2
        }
        
        
        
        
        var pinSelfX = self.bounds.width * lengthRate
        if pinSelfX > self.bounds.width - arrowImageView.bounds.width/2{
            pinBrothViewX = self.bounds.width - arrowImageView.bounds.width/2
        }else if pinSelfX < arrowImageView.bounds.width/2{
            pinSelfX = arrowImageView.bounds.width/2
        }
        
        var pingSelfY = self.bounds.height * lengthRate
        if pingSelfY > self.bounds.height - arrowImageView.bounds.height/2 {
            pingSelfY = self.bounds.height - arrowImageView.bounds.height/2
        }else if pingSelfY < arrowImageView.bounds.height/2 {
            pingSelfY = arrowImageView.bounds.height/2
        }
        
        pinBrothViewX += self.brotherView.frame.origin.x
        pinBrothViewY += self.brotherView.frame.origin.y

        
        switch self.direction {
        case .top:
                arrowImageView.center = CGPoint(x: pinSelfX, y: self.bounds.height + arrowImageView.bounds.height/2)
                let selfCenterX = pinBrothViewX + bounds.width/2 - pinSelfX
                self.center = CGPoint(x: selfCenterX, y: brotherView.frame.origin.y - self.bounds.height/2 - arrowImageView.bounds.height)
                arrowImageView.transform = CGAffineTransform.identity
            break
        case .left:
            arrowImageView.center = CGPoint(x: self.bounds.width + arrowImageView.bounds.width/2, y: pingSelfY)
            let selfCenterY = pinBrothViewY + bounds.height/2 - pingSelfY
            self.center = CGPoint(x: brotherView.frame.origin.x - self.bounds.width/2 - arrowImageView.bounds.width, y: selfCenterY)
            arrowImageView.transform = CGAffineTransform(rotationAngle:-CGFloat(Double.pi/2))
            break
        case .bottom:
            arrowImageView.center = CGPoint(x: pinSelfX, y:  -arrowImageView.bounds.height/2)
            let selfCenterX = pinBrothViewX + bounds.width/2 - pinSelfX
            self.center = CGPoint(x: selfCenterX, y: brotherView.frame.maxY + self.bounds.height/2 + arrowImageView.bounds.height)
            arrowImageView.transform = CGAffineTransform(rotationAngle:CGFloat(Double.pi))
            break
        case .right:
            
            arrowImageView.center = CGPoint(x: -arrowImageView.bounds.width/2, y: pingSelfY)
            let selfCenterY = pinBrothViewY + bounds.height/2 - pingSelfY
            self.center = CGPoint(x: brotherView.frame.maxX + self.bounds.width/2 + arrowImageView.bounds.width , y: selfCenterY)
            arrowImageView.transform = CGAffineTransform(rotationAngle:CGFloat(Double.pi/2))
            break
        }
        radiuscornerView.frame = self.bounds
        radiuscornerView.layer.cornerRadius = 10
        radiuscornerView.layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
