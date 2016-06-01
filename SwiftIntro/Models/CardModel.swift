//
//  CardModel.swift
//  SwiftIntro
//
//  Created by Alexander Georgii-Hemming Cyon on 01/06/16.
//  Copyright © 2016 SwiftIntro. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]
protocol Model: ResponseCollectionSerializable, ResponseObjectSerializable {}

struct CardModel {
    var imageUrl: NSURL!
}

extension CardModel: Model {
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        //swiftlint:disable force_cast
        let media = representation["images"] as! JSON
        let image = media["standard_resolution"] as! JSON
        let imageUrlString = image["url"] as! String
        self.imageUrl = NSURL(string: imageUrlString)!
    }

    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [CardModel] {
        guard let representation = representation as? [JSON] else {
            print("bad format")
            return []
        }
        var cardModels: [CardModel] = []
        for cardRepresentation in representation {
            guard let card = CardModel(response: response, representation: cardRepresentation) else { continue }
            cardModels.append(card)
        }

        return cardModels
    }
}
