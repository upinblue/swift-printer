//
//  File.swift
//  
//
//  Created by Bastian Wirth on 24.02.21.
//

import Foundation
import PDFKit


public protocol Printable {
    func htmlRepresentation()->String
    
    func printableDocumentMetadata()->PrintableDocumentMetadata?
    
    var printableCompletionHandler: ((_ data: Data) -> Void)? { get set }
    
    var printer: PrinterCore { get }
    
    mutating func print(pdfData: @escaping (Data?) -> Void)
}


public extension Printable {
    var printer: PrinterCore {
        get {
            return PrinterCore()
        }
    }
    
    mutating func print(pdfData: @escaping (Data?) -> Void) {
        
        printableCompletionHandler = pdfData
        printer.print(printable: self)
                
    }
    
}



public extension Printable {
    func printableDocumentMetadata()->PrintableDocumentMetadata? {
        return nil // Standard implementation returns nil, so there is no metadata.
    }
}
