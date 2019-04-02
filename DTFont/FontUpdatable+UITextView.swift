//
//  FontUpdatable+UITextView.swift
//  DTFont
//
//  Created by Suguru Kishimoto on 9/27/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

private struct AssociatedKeys {
    static var dtFontKey = ""
    static var updaterKey = ""
}


extension FontUpdatable where Self: UITextView {
    
    private var fontMaker: (() -> UIFont?)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dtFontKey) as? () -> UIFont?
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.dtFontKey, (newValue as Any), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var updater: DTFontUpdater? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.updaterKey) as? DTFontUpdater
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.updaterKey, (newValue as Any), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func enableAutomaticFontUpdate(with font: @autoclosure @escaping () -> UIFont?, updateImmediately: Bool = true) {
        self.fontMaker = font
        let updater = DTFontUpdater()
        updater.updateHandler = { _ in
            DispatchQueue.main.async { [weak self] in
                self?.font = self?.fontMaker?()
            }
        }
        self.updater = updater
        
        if updateImmediately {
            self.font = font()
        }
    }
    
    public func disableAutomaticFontUpdate() {
        self.fontMaker = nil
        self.updater = nil
    }
}

extension UITextView: FontUpdatable {}
