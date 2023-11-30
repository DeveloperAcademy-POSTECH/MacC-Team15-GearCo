//
//  Network+.swift
//  Solidner
//
//  Created by 이재원 on 11/28/23.
//

import Foundation
import Firebase

extension CollectionReference {
    func getDocRef(_ email: String, id: String? = nil) -> DocumentReference {
        if let id {
            return self.document("\(email)_\(id)")
        }
        return self.document("\(email)")
    }
}


extension Query {
    func getDocumentsAsync() async throws -> QuerySnapshot {
        return try await withCheckedThrowingContinuation { continuation in
            self.getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let snapshot = snapshot {
                    continuation.resume(returning: snapshot)
                } else {
                    continuation.resume(throwing: NSError(domain: "FirestoreError", code: -1, userInfo: nil))
                }
            }
        }
    }
}
