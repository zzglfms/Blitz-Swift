//
//  MainTabBar.swift
//  Blitz
//
//  Created by ccccccc on 15/10/28.
//  Copyright © 2015年 cs490. All rights reserved.
//

import UIKit

class MainTabBar: UITabBar {


    lazy var TabBarButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        // 添加到父控件中
        self.addSubview(btn)
        return btn
        }()
    
    private let buttonCount = 5
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 设置每个按钮的宽高和基准尺寸
        let w = self.bounds.width / CGFloat(buttonCount)
        let h = self.bounds.height
        let frame = CGRectMake(0, 0, w, h)
        
        var index: CGFloat = 0
        for view in self.subviews {
            if (view is UIControl && !(view is UIButton)) {
                /**
                *  当前控件是响应者对象，并且不是 UIButton 类型时参照设置尺寸位置
                */
                view.frame = CGRectOffset(frame, index * w, 0)
                index += (index == 1) ? 2 : 1
            }
        }
        /**
        *  设置撰写按钮的尺寸和位置
        */
        self.TabBarButton.frame = frame
        self.TabBarButton.center = CGPointMake(self.bounds.width * 0.5, self.bounds.height * 0.5 )
    }
}
