//
//  BaClient.swift
//  YourTake
//
//  Created by Olivier Thomas on 2016-12-18.
//  Copyright © 2016 Enovi Inc. All rights reserved.
//

typealias BaBoolCompletionBlock = (Bool) -> Void
typealias BaStringCompletionBlock = (String) -> Void
typealias BaStringsCompletionBlock = ([String]) -> Void
typealias BaUserCompletionBlock = (User?) -> Void
typealias BaChallengeCompletionBlock = (Challenge?) -> Void
typealias BaChallengesCompletionBlock = ([Challenge]) -> Void
typealias BaTakeCompletionBlock = (Take?) -> Void
typealias BaTakesCompletionBlock = ([Take]) -> Void

protocol BaClient {
    // admin
    func register(username: String, password: String, email: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func login(username: String, password: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func resetPassword(for username: String, completion: @escaping BaBoolCompletionBlock) -> Void
    
    // social
    func getUser(completion: @escaping BaUserCompletionBlock) -> Void
    func getFriends(completion: @escaping BaStringsCompletionBlock) -> Void
    func addFriend(_ username: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func removeFriend(_ username: String, completion: @escaping BaBoolCompletionBlock) -> Void
    
    // challenges
    func getChallenge(with id: String, completion: @escaping BaChallengeCompletionBlock) -> Void
    func getChallenges(for friends: Bool, completion: @escaping BaChallengesCompletionBlock) -> Void
    func getChallenges(to date: Date, with maxCount: UInt, for friends: Bool, completion: @escaping BaChallengesCompletionBlock) -> Void
    func createChallenge(_ challenge: Challenge, completion: @escaping BaBoolCompletionBlock) -> Void
    func removeChallenge(with id: String, completion: @escaping BaBoolCompletionBlock) -> Void
    
    // takes
    func getTake(with id: String, completion: @escaping BaTakeCompletionBlock) -> Void
    func getTakes(for challengeId: String, completion: @escaping BaTakesCompletionBlock) -> Void
    func createTake(_ take: Take, completion: @escaping BaBoolCompletionBlock) -> Void
    func removeTake(with id: String, completion: @escaping BaBoolCompletionBlock) -> Void
    
    // vote
    func vote(with takeId: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func unvote(with takeId: String, completion: @escaping BaBoolCompletionBlock) -> Void
}

