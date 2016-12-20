//
//  APPBanners.swift
//  Plug Spot
//
//  Created by Molnar Kristian on 3/2/16.
//  Copyright © 2016 AzinecLLC. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

public class CPBanners: NSObject {
  
  var banner:UIView!           = nil
  var target:UIView!           = nil
  var tableTarget:UITableView! = nil
  var backgroundColor:UIColor! = nil
  var textColor:UIColor!       = .white
  var bannerText:String        = ""
  var bannerLabel:UILabel! = nil
  let bannerHeight:CGFloat = 10.0
  var visibilityDuration:Double = 2.0
  var isVibrating:Bool = false
  
  var APPColors: [String: UIColor] = [
    "navigationBar"  : UIColor(red: 31/255.0, green: 131/255.0, blue: 134/255.0, alpha: 1),
    "Info" : UIColor(red: 249/255.0, green: 198/255.0, blue: 108/255.0, alpha: 1),
    "Warning" : UIColor(red: 255/255.0, green: 0/255.0, blue: 64/255.0, alpha: 1),
    "Success1" : UIColor(red: 30/255.0, green: 160/255.0, blue: 73/255.0, alpha: 1),
    "Success" : UIColor(red: 31/255.0, green: 131/255.0, blue: 134/255.0, alpha: 1),
    "Default" : UIColor(red: 61/255.0, green: 130/255.0, blue: 134/255.0, alpha: 1),
    "title": UIColor(red: 246/255.0, green: 201/255.0, blue: 133/255.0, alpha: 1),
    ]

  
  public enum CHBannerTypes: String {
    case Info    = "Info"
    case Warning = "Warning"
    case Success = "Success"
    case Default = "Default"
  }
  
  override init() {
    super.init()
  }
  
  convenience init(withTarget targetView: UIView, andType type:CHBannerTypes) {
    self.init()
    self.target          = targetView
    self.backgroundColor = self.APPColors[type.rawValue]
    if type == .Warning {
      isVibrating = true
    }
  }
  
  convenience init(withTableTarget targetView: UITableView, andType type:CHBannerTypes) {
    self.init()
    self.tableTarget     = targetView
    self.backgroundColor = self.APPColors[type.rawValue]
  }
  
  public func showBannerForViewControllerAnimated(_ animated:Bool, message:String) {
    if message == "" {
      return
    }
    self.bannerText = message
    self.createBanner(message)
    self.target.addSubview(self.banner)
    self.target.bringSubview(toFront: self.banner)
    
    animated ? self.animateView(): setUpOpacity()
    
    if isVibrating {
      self.vibrating()
    }
    
    setTimeout(self.visibilityDuration, block: { () -> Void in
      self.dismissView()
    })
    
  }
  
  
  public func showBannerForViewControllerAnimatedWithReturning(_ animated:Bool, message:String) -> CPBanners {
    self.bannerText = message
    self.createBanner(message)
    self.target.addSubview(self.banner)
    self.target.bringSubview(toFront: self.banner)
    animated ? self.animateView(): setUpOpacity()
    
    return self
  }
  
  public func showBannerForTableViewControllerAnimated(_ animated:Bool, message:String) {
    self.bannerText = message
    self.tableTarget.addSubview(self.createBanner(message))
    animated ? self.animateView(): setUpOpacity()
    
    
    
    setTimeout(self.visibilityDuration, block: { () -> Void in
      self.dismissView()
    })
  }
  
  public func changeText(_ text:String) {
    DispatchQueue.main.async { () -> Void in
      self.bannerLabel.text = text
    }
  }
  
  func changeType(_ type:CHBannerTypes) {
    self.backgroundColor = self.APPColors[type.rawValue]
    if self.banner != nil {
      self.banner.backgroundColor = self.backgroundColor
    }
  }
  
  func createBanner(_ message:String) -> UIView {
    self.banner                 = UIView(frame: CGRect(x: 0, y: 64, width: self.target.frame.size.width, height: self.bannerHeight + 20))
    self.banner.backgroundColor = self.backgroundColor
    self.banner.layer.opacity   = 0
    self.bannerLabel                           = UILabel(frame: CGRect(x: 0, y: 10, width: self.target.frame.size.width, height: self.bannerHeight))
    self.bannerLabel.text                      = self.bannerText
    self.bannerLabel.textColor                 = self.textColor
    self.bannerLabel.textAlignment             = .center
    self.bannerLabel.lineBreakMode = .byWordWrapping
    self.bannerLabel.numberOfLines = 3
    
    
    banner.addSubview(bannerLabel)
    return banner
  }
  
  func changeBannerTopmargin(_ margin:CGFloat) {
    DispatchQueue.main.async { () -> Void in
      self.banner.frame = CGRect(x: 0, y: margin, width: self.target.frame.size.width, height: self.bannerHeight)
    }
  }
  
  func dismissView(_ withTimeOut:Bool = false) {
    if banner != nil {
      var time:Double = 0.0
      if withTimeOut {
        time = 2.0
      }
      
      UIView.animate(withDuration: 1.0, delay: time, options: .curveEaseOut, animations: {
        self.banner.layer.opacity = 0
      }, completion: { finished in
        self.banner.removeFromSuperview()
      })
    }
  }
  
  public func forceDismiss(){
    DispatchQueue.main.async { () -> Void in
      self.banner.layer.opacity = 0
      self.banner.removeFromSuperview()
    }
  }
  
  func animateView() {
    var frame = banner.frame
    frame.origin.x = -1 * frame.size.width
    self.banner.layer.opacity = 0
    
    UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
      self.banner.layer.opacity = 1
    }, completion: { finished in
      
    })
  }
  
  func setUpOpacity() {
    self.banner.layer.opacity = 1
  }
  
  func setTimeout(_ delay:TimeInterval, block:@escaping ()->Void) -> Timer {
    return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
  }
  
  func vibrating() {
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
  }
  
}
