//
//  FirebaseStorable.swift
//  iOSBanking
//
//  Created by Santosh KC on 17/08/2022.
//

import FirebaseFirestore

protocol FireStoreStorable {
    func collection(_ collectionPath: String) -> CollectionReference
}

extension Firestore: FireStoreStorable {}
