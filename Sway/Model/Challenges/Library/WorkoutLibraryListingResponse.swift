//
//  WorkoutListingResponnse.swift
//  Sway
//
//  Created by Admin on 13/07/21.
//

import Foundation

/*
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct WorkoutLibraryListingResponse: Codable {
    var statusCode : Int = 400
    let type : String?
    let message : String?
    let data : LibraryListingModel?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case type = "type"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode) ?? 400
        type = try values.decodeIfPresent(String.self, forKey: .type)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(LibraryListingModel.self, forKey: .data)
    }

}


struct LibraryListingModel : Codable {
    let libraryItems : [LibraryItemModel]?
    let total : Int?
    let page : Int?
    let total_page : Int?
    let next_hit : Int?
    let limit : Int?

    enum CodingKeys: String, CodingKey {

        case libraryItems = "data"
        case total = "total"
        case page = "page"
        case total_page = "total_page"
        case next_hit = "next_hit"
        case limit = "limit"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        libraryItems = try values.decodeIfPresent([LibraryItemModel].self, forKey: .libraryItems)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        total_page = try values.decodeIfPresent(Int.self, forKey: .total_page)
        next_hit = try values.decodeIfPresent(Int.self, forKey: .next_hit)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
    }

}

struct LibraryItemModel : Codable {
    let _id : String?
    let name : String?
    let imageUrl : ImageUrl?
    let duration : Int?
    let isAddedInMyLibrary : Bool?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case name = "name"
        case imageUrl = "imageUrl"
        case duration = "duration"
        case isAddedInMyLibrary = "isAddedInMyLibrary"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        imageUrl = try values.decodeIfPresent(ImageUrl.self, forKey: .imageUrl)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        isAddedInMyLibrary = try values.decodeIfPresent(Bool.self, forKey: .isAddedInMyLibrary)
    }

}
