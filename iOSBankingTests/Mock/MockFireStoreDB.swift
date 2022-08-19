//
//  MockFireStoreDB.swift
//  iOSBankingTests
//
//  Created by Santosh KC on 18/08/2022.
//

import Foundation
import Firebase
@testable import iOSBanking

class MockFireStoreDB: FireStoreStorable {
    
    var collectionName = ""
    var documentPath: String {
        return self.ref.documentPath
    }
    var storedData: [String:Any] {
        return self.ref.documentRef.data
    }
    var merge: Bool {
        return self.ref.documentRef.merge
    }
    
    private var ref: MockCollectionReference!
    
    func collection(_ collectionPath: String) -> CollectionReference {
        let ref: MockCollectionReference =  customInit()
        self.ref = ref
        self.collectionName = collectionPath
        return ref
    }
}

class MockCollectionReference : CollectionReference {
    var documentPath = ""
    var documentRef: MockDocumentReference!
    
    override func document(_ documentPath: String) -> DocumentReference {
        self.documentPath = documentPath
        documentRef = customInit()
        return documentRef
    }
    
    override func document() -> DocumentReference {
        documentRef
    }
}

class MockDocumentReference: DocumentReference {
    var data: [String: Any] = [:]
    var merge = false
    
    override func setData(_ documentData: [String : Any], merge: Bool) {
        self.data = documentData
        self.merge = merge
    }
    
    override func setData(_ documentData: [String : Any], merge: Bool) async throws {
        self.data = documentData
        self.merge = merge
    }
}
