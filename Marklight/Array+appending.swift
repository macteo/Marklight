//
//  Array+appending
//
//  Created by Christian Tietze on 2017-07-19.
//  Copyright © 2016 MacTeo. LICENSE for details.
//

extension Array {
    func appending(contentsOf other: [Element]) -> [Element] {
        var result = self
        result.append(contentsOf: other)
        return result
    }
}
