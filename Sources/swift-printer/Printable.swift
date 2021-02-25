//
//  Printable.swift
//  
//
//  Created by Bastian Wirth on 24.02.21.
//

import Foundation

/// Enables printing to PDF-capabilities for the object that inerhits this protocol.
/// Printable can also be used nested to create a tree structure of printables and to combine them into one document.
public protocol Printable {
    /// html representation of the parent.
    /// Define how the object has to be represented. Base64 images are supported.
    func htmlRepresentation()->String
    
    /// Provides metadata - for example title or author - to the printable.
    func printableDocumentMetadata()->PrintableDocumentMetadata?
    
    /// Get's called when the print is done.
    var printableCompletionHandler: ((_ data: Data) -> Void)? { get set }
    
    /// Instantiate this object once, if you plan to print. It will be used later on by the protocol.
    var printerHelper: PrinterHelper? { get }
    
    /// Prints the representation asynchronously to a PDF and calls the completion handler.
    /// By default there is no need for you to override this function. Just use the basic implementation.
    mutating func print(pdfData: @escaping (Data?) -> Void)
}


public extension Printable {

    mutating func print(pdfData: @escaping (Data?) -> Void) {
        
        printableCompletionHandler = pdfData
        printerHelper!.print(printable: self)
                
    }
    
}



public extension Printable {
    func printableDocumentMetadata()->PrintableDocumentMetadata? {
        return nil // Standard implementation returns nil, so there is no metadata.
    }
}
