//
//  FadingCircleView.swift
//  Drink
//
//  Created by Luis Gonzalez on 7/27/21.
//

import Foundation
import UIKit


class FadingCircleView: UIView {
    
    let circle1 = UIView();
    let circle2 = UIView();
    let circle3 = UIView();
    
    var circleArray: [UIView] = [];
    
    
    
    override init(frame: CGRect){
        super.init(frame: frame);
        configure();
    }
    
    private func configure()->Void {
        translatesAutoresizingMaskIntoConstraints = false;
        circleArray = [circle1, circle2, circle3];
        for i in circleArray {
            i.frame = CGRect(x: -20, y: 5, width: 30, height: 30);
            i.layer.cornerRadius = 15;
            i.alpha = 0;
            i.backgroundColor = .systemPink;
            
            addSubview(i);
        }
        
    }
    
    public func animate() {
        var delay: Double = 0;
        for i in circleArray {
            animateCircle(i, delay: delay);
            delay += 0.95;
        }
    }
    
    private func animateCircle(_ circle: UIView, delay: Double){
        UIView.animate(withDuration: 0.8, delay: delay, options: .curveLinear) {
            // Fade in
            circle.alpha = 1;
            circle.frame = CGRect(x: 35, y: 5, width: 30, height: 30);
        } completion: { (completed) in
            UIView.animate(withDuration: 1.3, delay: 0, options: .curveLinear) {
                // Middle circle
                circle.frame = CGRect(x: 85, y: 5, width: 30, height: 30);
            } completion: { (complete) in
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear) {
                    circle.alpha = 0;
                    circle.frame = CGRect(x: 140, y: 5, width: 30, height: 30);
                } completion: { (complete) in
                    // set to original
                    circle.frame = CGRect(x: -20, y: 5, width: 30, height: 30);
                    // Recursive call 
                    self.animateCircle(circle, delay: 0);
                }

            }

        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("CODER MISSING");
    }
}
