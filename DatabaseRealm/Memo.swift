//
//  Memo.swift
//  DatabaseRealm
//
//  Created by 渡邉昇 on 2022/09/03.
//

import Foundation
import RealmSwift

class Memo: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
}
