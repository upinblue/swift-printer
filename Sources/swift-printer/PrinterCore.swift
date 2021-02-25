//
//  File.swift
//  
//
//  Created by Bastian Wirth on 24.02.21.
//

import UIKit
import WebKit

public class PrinterCore: NSObject, WKNavigationDelegate {

    private let printerViewController = PrinterViewController()
    
    private var printable: Printable?
    
    public override init() {
        super.init()
        
        printerViewController.view.alpha = 0
        printerViewController.webView.navigationDelegate = self
    }
    
    func print(printable: Printable) {
        self.printable = printable
        printerViewController.webView.loadHTMLString(printable.htmlRepresentation(), baseURL: nil)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Swift.print(error.localizedDescription)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let renderer = UIPrintPageRenderer()
        renderer.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)
        
        let printableRect = CGRect(x: 20, y: 20, width: 595.2 - 20, height: 841.8 - 20)
        let paperRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        
        renderer.setValue(NSValue(cgRect: printableRect), forKey: "printableRect")
        renderer.setValue(NSValue(cgRect: paperRect), forKey: "paperRect")
        
        let data = renderer.pdf(title: printable?.printableDocumentMetadata()?.title ?? "")
        
        printable?.printableCompletionHandler?(data)
        printerViewController.webView.removeFromSuperview()
        printable?.printableCompletionHandler = nil
    }
    
    private class PrinterViewController: UIViewController {
        
        let webView = WKWebView()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            self.view.addSubview(webView)
            let rootVC = UIApplication.shared.windows.first?.rootViewController
            rootVC?.addChild(self)
            rootVC?.view.insertSubview(self.view, at: 0)
        }
    }
    
}

fileprivate extension UIPrintPageRenderer {
    func pdf(title: String?)->Data {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect(x: 0, y: 0, width: 595.2, height: 841.8), [kCGPDFContextTitle : title ?? ""])
        
        self.prepare(forDrawingPages: NSMakeRange(0, self.numberOfPages))
        
        let bounds = UIGraphicsGetPDFContextBounds()
        
        for i in 0..<numberOfPages {
            UIGraphicsBeginPDFPage()
            
            self.drawPage(at: i, in: bounds)
        }
        UIGraphicsEndPDFContext()
        
        return data as Data
    }
}
