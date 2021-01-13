//
//  AppDelegate.swift
//  SzContext
//
//  Created by Jiawei Duan on 2018/8/25.
//  Copyright © 2018 Jiawei Duan. All rights reserved.
//
import Foundation
import Cocoa
import ServiceManagement
import LQ3C7Y6F8J_com_roadtodream_SzContextXPCHelper
import FinderSync

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var firstStartUpWindowController : NSWindowController?
    
    var mainWindow : NSWindow?
    let userDefaults = UserDefaults.init(suiteName: APP_GROUP)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(self.handleAppleEvent(event:replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        SMLoginItemSetEnabled(HELPER_BUNDLE as CFString, true)
        mainWindow = NSApplication.shared.mainWindow
        if !PreferenceManager.bool(for: .notFirstLaunch) {
            PreferenceManager.reset()
            PreferenceManager.set(for: .notFirstLaunch, with: true)
            openFirstStartUpWindow()
        }
        if PreferenceManager.string(for: .userDefaultsVersion) != USER_DEFAULTS_VERSION {
            _ = NotifyManager.messageNotify(message: NSLocalizedString("informational.updateUserDefaults", comment: ""), inform: "", style: .informational)
            PreferenceManager.resetAccessFolder()
            PreferenceManager.resetUserDefaultsVersion()
        }
        BookmarkManager.loadMainBookmarks(with: .bookmarkAccessFolder)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender:NSApplication) -> Bool{
        return true
    }
    
    func applicationWillTerminate(_ notification: Notification) {

    }
    
    @objc func handleAppleEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        guard let appleEventDescription = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) else {
            return
        }
        guard let appleEventURLString = appleEventDescription.stringValue else {
            return
        }
//        if let appleEventURL = URL(string: appleEventURLString) {
//            let urlComponents = NSURLComponents(url: appleEventURL, resolvingAgainstBaseURL: false)
//            let items = (urlComponents?.queryItems)! as [NSURLQueryItem]
//            if (appleEventURL.scheme == URL_SCHEME_NAME) {
//                NotifyManager.messageNotify(message: "Congrats you found a hidden feature! Function still in development, stay tuned!", inform: "", style: .informational)
//            }
//        }
    }
    
    
    func openFirstStartUpWindow(){
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        firstStartUpWindowController = (storyboard.instantiateController(withIdentifier: "tipFirstStartUpWindowControllerID") as! NSWindowController)
        firstStartUpWindowController?.showWindow(self)
        firstStartUpWindowController?.window?.level = .floating
    }
    
}
