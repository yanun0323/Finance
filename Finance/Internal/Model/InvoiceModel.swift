import SwiftUI

struct InvoiceModel: Hashable, Identifiable {
    var id = UUID()
    var date: Date
    var cost: Decimal
    var description: String?

    init(date d: Date,
         cost c: Decimal,
         description des: String? = nil)
    {
        date = d
        cost = c
        description = des
    }
}
