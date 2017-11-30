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
typealias BaStringsOptionalCompletionBlock = ([String]?) -> Void
typealias BaUserCompletionBlock = (User?) -> Void
typealias BaChallengeDtoCompletionBlock = (ChallengeDto?) -> Void
typealias BaChallengeDtoListCompletionBlock = ([ChallengeDto]) -> Void
typealias BaTakeDtoCompletionBlock = (TakeDto?) -> Void
typealias BaTakeDtoListCompletionBlock = ([TakeDto]) -> Void
typealias BaImageCompletionBlock = (UIImage?) -> Void

protocol BaClient {
    // admin
    func register(username: String, password: String, email: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func login(username: String, password: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func resetPassword(for username: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func getServerTime(completion: @escaping BaStringCompletionBlock) -> Void
    
    // social
    func getUser(completion: @escaping BaUserCompletionBlock) -> Void
    func getFollowing(completion: @escaping BaStringsOptionalCompletionBlock) -> Void
    func getFollowers(completion: @escaping BaStringsOptionalCompletionBlock) -> Void
    func getUsers(completion: @escaping BaStringsOptionalCompletionBlock) -> Void
    func addFriend(_ username: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func removeFriend(_ username: String, completion: @escaping BaBoolCompletionBlock) -> Void
    
    // challenges
    func createChallenge(_ challenge: ChallengeDto, completion: @escaping BaBoolCompletionBlock) -> Void
    func removeChallenge(with id: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func getChallengeDto(with id: String, completion: @escaping BaChallengeDtoCompletionBlock) -> Void
    func getChallengeDtoList(for friends: Bool, completion: @escaping BaChallengeDtoListCompletionBlock) -> Void
    func getChallengeDtoList(to date: Date, with maxCount: UInt, for friends: Bool, completion: @escaping BaChallengeDtoListCompletionBlock) -> Void
    
    // takes
    func createTake(_ take: TakeDto, completion: @escaping BaBoolCompletionBlock) -> Void
    func removeTake(with id: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func getTakeDto(with id: String, completion: @escaping BaTakeDtoCompletionBlock) -> Void
    func getTakeDtoForCurrentUser(fromChallenge challengeId: String, completion: @escaping BaTakeDtoCompletionBlock) -> Void
    func getTakeDtoList(for challengeId: String, completion: @escaping BaTakeDtoListCompletionBlock) -> Void
    
    // vote
    func vote(with takeId: String, completion: @escaping BaBoolCompletionBlock) -> Void
    func unvote(with takeId: String, completion: @escaping BaBoolCompletionBlock) -> Void
    
    // download
    func downloadImage(with id: String, completion: @escaping BaImageCompletionBlock)
}

