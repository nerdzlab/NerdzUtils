//
//  LoadableButton.swift
//  
//
//  Created by Roman Kovalchuk on 28.04.2021.
//

import UIKit

open class LoadableButton: UIButton {
    
    public var onStartLoading: (() -> Void)?
    public var onFinishLoading: (() -> Void)?
    // Activity indicator spacing, must be set before reasingning of activity indicator view
    public var topBottomIndicatorPadding = CGFloat(10)

    // Variable that represents loading state, change it if you want to show/hide loading indicator
    public var isLoading: Bool = false {
        didSet {
            configureLoadingStateChange()
        }
    }
    
    // If you don't want to use default activity indicator, or want to customize it, you should set this variable
    public var activityIndicatorView: UIView {
        get {
            indicatorView
        }
        
        set {
            if indicatorView.superview != nil {
                indicatorView.removeFromSuperview()
            }
            
            indicatorView = newValue
            configureView()
        }
    }
    
    private var indicatorView: UIView = UIActivityIndicatorView()
    private var titleBeforeLoadingStateChange: String?
    private var imageBeforeLoadingStateChange: UIImage?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureView()
    }
    
    private func configureView() {
        activityIndicatorView.tintColor = .white
        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(
            item: activityIndicatorView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: topBottomIndicatorPadding
        ).isActive = true
        
        NSLayoutConstraint(
            item: activityIndicatorView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: -topBottomIndicatorPadding
        ).isActive = true
        
        NSLayoutConstraint(
            item: activityIndicatorView,
            attribute: .width,
            relatedBy: .equal,
            toItem: activityIndicatorView,
            attribute: .height,
            multiplier: 1,
            constant: 0
        ).isActive = true
        
        NSLayoutConstraint(
            item: activityIndicatorView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        ).isActive = true
        
        NSLayoutConstraint(
            item: activityIndicatorView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        ).isActive = true
        
        activityIndicatorView.isHidden = true
    }
    
    private func configureLoadingStateChange() {
        if isLoading {
            titleBeforeLoadingStateChange = title(for: .normal)
            imageBeforeLoadingStateChange = image(for: .normal)
        }
        
        setTitle(isLoading ? "" : titleBeforeLoadingStateChange, for: .normal)
        setImage(isLoading ? nil : imageBeforeLoadingStateChange, for: .normal)
        activityIndicatorView.isHidden = !isLoading
        isUserInteractionEnabled = !isLoading
        isLoading ? onStartLoading?() : onFinishLoading?()
    }
}
