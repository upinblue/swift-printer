//
//  File.swift
//  
//
//  Created by Bastian Wirth on 24.02.21.
//

import Foundation
import PDFKit

public protocol PrintableCore {
    
}


public protocol Printable: PrintableCore {
    func htmlRepresentation()->String
    
    func printableDocumentMetadata()->PrintableDocumentMetadata?
    
    var printableCompletionHandler: ((_ data: Data) -> Void)? { get set }
    
    mutating func print(pdfData: @escaping (Data?) -> Void)
}


extension Printable {
    
    
    mutating func print(pdfData: @escaping (Data?) -> Void) {
        
        printableCompletionHandler = pdfData
        
        let printer = PrinterCore()
        printer.print(printable: self)
                
    }
    
}



public extension Printable {
    func printableDocumentMetadata()->PrintableDocumentMetadata? {
        return nil // Standard implementation returns nil, so there is no metadata.
    }
}
