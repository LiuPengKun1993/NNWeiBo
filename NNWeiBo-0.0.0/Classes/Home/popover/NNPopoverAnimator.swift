//
//  NNPopoverAnimator.swift
//  NNWeiBo-0.0.0
//
//  Created by iOS on 16/10/11.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

// 定义常量保存通知的名称
let NNPopoverAnimatorWillShow = "NNPopoverAnimatorWillShow"
let NNPopoverAnimatorWillDismiss = "NNPopoverAnimatorWillDismiss"



class NNPopoverAnimator: NSObject,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    /// 记录当前是否是展开
    var isPresent: Bool = false
    /// 定义属性保存菜单的大小
    var presentFrame = CGRectZero
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
            
            let presentedVc = NNPresentationController(presentedViewController: presented, presentingViewController: presenting)
            // 设置菜单的大小
            presentedVc.presentFrame = presentFrame
            
            return presentedVc
        }
        
        // MARK: - 只要实现了一下方法, 那么系统自带的默认动画就没有了, "所有"东西都需要程序员自己来实现
    
        func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            isPresent = true
            // 发送通知, 通知控制器即将展开
            NSNotificationCenter.defaultCenter().postNotificationName(NNPopoverAnimatorWillShow, object: self)
            return self
        }
        
        /**
         告诉系统谁来负责Modal的消失动画
         */
        func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
            isPresent = false
            // 发送通知, 通知控制器即将消失
            NSNotificationCenter.defaultCenter().postNotificationName(NNPopoverAnimatorWillDismiss, object: self)
            return self
        }
        // MARK: - UIViewControllerAnimatedTransitioning
        /**
         返回动画时长
         */
        func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
            return 0.5
        }
        
        
        /**
         告诉系统如何动画, 无论是展现还是消失都会调用这个方法
         */
        
        func animateTransition(transitionContext:UIViewControllerContextTransitioning) {
        // 1.拿到展现视图
        if isPresent {
            
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            
            // 注意: 一定要将视图添加到容器上
            transitionContext.containerView()?.addSubview(toView)
            
            // 设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            // 2.执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { ()-> Void in
                // 2.1清空transform
                toView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                
                // 2.2动画执行完毕, 一定要告诉系统
                transitionContext.completeTransition(true)
            }
            
        } else {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                // 注意:由于CGFloat是不准确的, 所以如果写0.0会没有动画
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.0001)}, completion: { (_) -> Void in
                    
                    // 如果不写, 可能导致一些未知错误
                    transitionContext.completeTransition(true)
            })
        }
    }
}
