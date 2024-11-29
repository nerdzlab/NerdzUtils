//
//  LoadableButton.swift
//
//
//  Created by Roman Kovalchuk on 28.04.2021.
//

#if canImport(UIKit)

import UIKit

open class LoadableButton: UIButton {
    public typealias LoadableButtonEmptyAction = () -> Void
    
    private enum Constants {
        static let defaultPadding: CGFloat = 10
    }
        
    public var onStartLoading: LoadableButtonEmptyAction?
    public var onFinishLoading: LoadableButtonEmptyAction?
    
    // Activity indicator spacing, must be set before reasingning of activity indicator view
    public var topBottomIndicatorPadding: CGFloat = Constants.defaultPadding

    // Variable that represents loading state, change it if you want to show/hide loading indicator
    public var isLoading: Bool = false {
        didSet {
            guard oldValue != isLoading else {
                return
            }
            
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
    
    private var titleBeforeLoadingStateChange: String?
    private var imageBeforeLoadingStateChange: UIImage?
    
    private var indicatorView: UIView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.tintColor = .white
        return activityIndicatorView
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureView()
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        
        if isLoading && title != nil {
            titleBeforeLoadingStateChange = title
        }
    }
    
    public override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        
        if isLoading && image != nil {
            imageBeforeLoadingStateChange = image
        }
    }
    
    private func configureView() {
        addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicatorView.topAnchor
            .constraint(equalTo: self.topAnchor, constant: topBottomIndicatorPadding).isActive = true
        activityIndicatorView.bottomAnchor
            .constraint(equalTo: self.bottomAnchor, constant: -topBottomIndicatorPadding).isActive = true
        activityIndicatorView.heightAnchor
            .constraint(equalTo: activityIndicatorView.widthAnchor).isActive = true
        activityIndicatorView.centerYAnchor
            .constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.centerXAnchor
            .constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func configureLoadingStateChange() {
        if isLoading {
            titleBeforeLoadingStateChange = title(for: .normal)
            imageBeforeLoadingStateChange = image(for: .normal)
        }
        
        setTitle(isLoading ? nil : titleBeforeLoadingStateChange, for: .normal)
        setImage(isLoading ? nil : imageBeforeLoadingStateChange, for: .normal)
        
        isUserInteractionEnabled = !isLoading
        activityIndicatorView.isHidden = !isLoading
        
        if let activityIndicatorView = activityIndicatorView as? UIActivityIndicatorView {
            isLoading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
        }
        
        isLoading ? onStartLoading?() : onFinishLoading?()
    }
}


#endif
