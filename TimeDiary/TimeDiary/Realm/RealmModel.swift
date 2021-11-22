//
//  RealmModel.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/22.
//

import Foundation
import RealmSwift

//UserDiary: 각각의 다이어리 데이터를 저장(제목, 내용, 날짜, 분류)
//@persisted: 컬럼 이름
class UserDiary: Object {

    @Persisted var title: String?   //다이어리 제목
    @Persisted var content: String? //다이어리 내용
    @Persisted var date = Date()    //날짜
    @Persisted var tag: String      //타임스탬프 분류

    
    //PK(필수) : Int, String, UUID, ObjectID ->
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(title: String?, content: String?, date: Date) {
        
        self.init()
        
        self.title = title
        self.content = content
        self.date = date
        

    }
}

//UserTag: 사용자가 지정한 분류 값을 저장
class UserTag: Object {
    
    @Persisted var tag: String
    @Persisted var contentNum: Int
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(tag: String, contentNum: Int) {
        self.init()
        
        self.tag = tag
        self.contentNum = contentNum
    }
    
}

