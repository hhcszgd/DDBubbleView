//
//  ViewController.swift
//  DDBubbleView
//
//  Created by WY on 2019/4/17.
//  Copyright © 2019 WY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let forcePointView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(forcePointView)
        forcePointView.backgroundColor = .orange
        forcePointView.bounds = CGRect(x: 0, y: 0, width: 66, height: 66)
        forcePointView.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true )
        DDBubbleView.show(forcePointView, 0.5, 0.7, .top) { (bubble) -> (CGSize) in
            //            bubble.bounds = CGRect(x: 0, y: 0, width: 300, height: 66)
            //            return CGSize(width: 100, height: 44)
            
            
            let titleLabel  = UILabel()
            titleLabel.backgroundColor = UIColor.white
            titleLabel.textAlignment = .center
            bubble.addSubview(titleLabel)
            titleLabel.text = "nothing to be show"
            titleLabel.ddSizeToFit(contentInset: UIEdgeInsets(top: 50, left: 10, bottom: 50, right: 10))
            bubble.bounds = CGRect(origin: CGPoint.zero, size: titleLabel.bounds.size)
            titleLabel.frame = bubble.bounds
            return titleLabel.bounds.size
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            DDBubbleView.removeFrom(brotherView: self.forcePointView)
        }
    }

}

extension UIView{
    public func ddSizeToFit( contentInset : UIEdgeInsets = UIEdgeInsets.zero) {
        self.sizeToFit()
        let frame = self.bounds
        self.contentMode = UIView.ContentMode.center
        self.bounds = CGRect(x: 0, y: 0, width: frame.width + (contentInset.left + contentInset.right), height: frame.height + (contentInset.top + contentInset.bottom))
    }
}
