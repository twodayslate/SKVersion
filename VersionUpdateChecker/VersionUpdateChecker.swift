//
//  VersionUpdate.swift
//  VersionUpdate
//
//  Created by Zachary Gorak on 9/11/19.
//  Copyright © 2019 Zac Gorak. All rights reserved.
//

import Foundation
import Version

extension Bundle {
    /// Checks if this bundle has an update available on the App Store
    ///
    /// Error will be URLError.badURL if the `bundleIdentifier` and the `version` is nil
    /// - parameters:
    ///     - bundleId: the bundle identifier
    ///                 The default value is `bundleIdentifier`
    ///     - version: the version to compare against
    ///                 The default value is `version`
    ///     - block: callback
    ///     - hasUpdate: Whether or not an update is available on the App Store
    ///     - version: App Store Version available
    ///     - error: Any potential errors
    public func hasAppStoreUpdate(with bundleId: String? = nil, version: Version? = nil, completion block: @escaping (_ hasUpdate: Bool, _ version: Version?, _ error: Error?)->Void) {
        guard let bundleId = bundleId ?? self.bundleIdentifier, let version = version ?? self.version else {
            block(false, nil, URLError(.badURL))
            return
        }
        VersionUpdateChecker(bundleId).hasAppStoreUpdate(completion: block, fromVersion: version)
    }
}

/// Version Update Checker
/// - Reference: https://stackoverflow.com/questions/6256748/check-if-my-app-has-a-new-version-on-appstore
open class VersionUpdateChecker {
    /// URL used to check for new version results
    open var checkUrl: URL? {
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(self.bundleId)")
        return url
    }
    
    /// Bundle Identifier
    public let bundleId: String
    
    
    /// - parameter bundleId: bundle identifier
    public init(_ bundleId: String) {
        self.bundleId = bundleId
    }
    
    /// Session used for creating the data task
    public var session = URLSession.shared
    
    /// Checks if there is an App Store update
    open func hasAppStoreUpdate(completion block: @escaping ((Bool, Version?, Error?)->Void), fromVersion: Version) {
        guard let checkUrl = self.checkUrl else {
            block(false, nil, URLError(.badURL))
            return
        }
        
        self.session.dataTask(with: checkUrl) { (data, response, error) in
            guard error == nil else {
                block(false, nil, error)
                return
            }
            
            do {
                guard let reponseJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any],
                    let result = (reponseJson["results"] as? [Any])?.first as? [String: Any],
                    let versionString = result["version"] as? String, let version = Version(versionString)
                    else{
                        block(false, nil, URLError(.badServerResponse))
                        return
                }
                
                block(fromVersion < version, version, nil)
                return
            } catch {
                block(false, nil, error)
                return
            }
        }.resume()
    }
}
