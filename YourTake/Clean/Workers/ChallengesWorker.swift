//
//  ChallengesWorker.swift
//  YourTakeClean
//
//  Created by John Buonassisi on 2017-03-28.
//  Copyright (c) 2017 JAB. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

class ChallengesWorker
{
  var challengesStore: ChallengesStoreProtocol
  
  init(challengesStore: ChallengesStoreProtocol)
  {
    self.challengesStore = challengesStore
  }
  
  func fetchChallenges(completionHandler: @escaping (_ challenges: [ChallengeDto]) -> Void)
  {
    challengesStore.fetchChallenges { (challenges: () throws -> [ChallengeDto]) -> Void in
      do {
        let challenges = try challenges()
        completionHandler(challenges)
      } catch {
        completionHandler([])
      }
    }
  }
  
  func fetchFriendChallenges(completionHandler: @escaping (_ challenges: [ChallengeDto]) -> Void)
  {
    challengesStore.fetchFriendChallenges { (challenges: () throws -> [ChallengeDto]) -> Void in
      do {
        let challenges = try challenges()
        completionHandler(challenges)
      } catch {
        completionHandler([])
      }
    }
  }
  
  func downloadImage(with id: String, completion: @escaping (UIImage?) -> Void) {
    challengesStore.downloadImage(with: id, completion: completion)
  }
  
  func getNumberOfVotes(for challengeId: String, completion: @escaping (UInt) -> Void) {
    challengesStore.getNumberOfVotes(for: challengeId, completion: completion)
  }
}

protocol ChallengesStoreProtocol
{
  func fetchChallenges(completionHandler: @escaping (_ challenges: [ChallengeDto],_ error: ChallengesStoreError?) -> Void)
  
  func fetchChallenges(completionHandler: @escaping ChallengesStoreFetchChallengesCompletionHandler)
  
  func fetchChallenges(completionHandler: @escaping (_ challenges: () throws -> [ChallengeDto]) -> Void)
  
  func fetchFriendChallenges(completionHandler: @escaping (_ challenges: () throws -> [ChallengeDto]) -> Void)
  
  func downloadImage(with id: String, completion: @escaping (UIImage?) -> Void)
  
  func getNumberOfVotes(for challengeId: String, completion: @escaping (UInt) -> Void)
}

typealias ChallengesStoreFetchChallengesCompletionHandler = (_ result: ChallengesStoreResult<[ChallengeDto]>) -> Void

enum ChallengesStoreResult<U>
{
  case Success(result:U)
  case Failure(error: ChallengesStoreError)
}


enum ChallengesStoreError: Equatable, Error
{
  case CannotFetch(String)
}

func ==(lhs: ChallengesStoreError, rhs: ChallengesStoreError) -> Bool
{
  switch (lhs, rhs) {
  case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
  default: return false
  }
}