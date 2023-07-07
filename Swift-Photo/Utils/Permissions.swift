//
//  Permissions.swift
//  Swift-Photo
//
//  Created by k2hoon on 2023/07/08.
//

import Foundation
import Combine
import Photos

enum PermissionError: Error {
    case denied
    case restricted
    case limited
    case unknown
}

extension PermissionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .denied: return NSLocalizedString("Photo access is denied", comment: "")
        case .restricted: return NSLocalizedString("Photo access is restricted", comment: "")
        case .limited: return NSLocalizedString("Photo access is restricted", comment: "")
        case .unknown: return NSLocalizedString("Can not access photo", comment: "")
        }
    }
}

class Permission {
    func requestPhotoStatus(withStatus completion: @escaping (_ status: PHAuthorizationStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        completion(status)
    }
    
    func requestPhoto(withError completion: @escaping (_ error: Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .denied, .notDetermined:
                print("requestPhoto", "Album access denied or notDetermined")
                completion(PermissionError.denied)
            case .restricted:
                print("requestPhoto", "Album access restricted")
                completion(PermissionError.restricted)
            case .authorized, .limited:
                print("requestPhoto", "Album access granted")
                completion(nil)
            @unknown default:
                print("requestPhoto", "Capture Deivce permission unknown")
                completion(PermissionError.unknown)
            }
        }
    }
}

