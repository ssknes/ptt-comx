//
//  Hedge.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 16/1/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
class HedgeSett: PropertyNames {
    var function_id = ""
    var function_desc = ""
    var result_namespace = ""
    var result_status = ""
    var result_desc = ""
    var req_transaction_id = ""
    var transaction_id = ""
    var response_message = ""
    var system = ""
    var system_type = ""
    var type = ""
    var action = ""
    var status = ""
    
    var company = ""
    var company_code = ""
    var counter_party = ""
    var created_date = ""
    var frame_type = ""
    var is_generate = ""
    var payment_date = ""
    var purchase_no = ""
    var settlement_amount = ""
    var settlement_period = ""
    var total_volume_bbl = ""
    var total_volume_ton = ""
    
    var brief = ""
    
    init() {
        // do nothing
    }
}

class HedgeTckt: PropertyNames {
    var function_id = ""
    var function_desc = ""
    var result_namespace = ""
    var result_status = ""
    var result_desc = ""
    var req_transaction_id = ""
    var transaction_id = ""
    var response_message = ""
    var system = ""
    var system_type = ""
    var type = ""
    var action = ""
    var status = ""
    
    var committee_fw = ""
    var company = ""
    var company_code = ""
    var counter_party = ""
    var is_generate = ""
    var price = ""
    var settle_amount = ""
    var settle_amount_perbbl = ""
    var settle_amount_permt = ""
    var tenor_period = ""
    var ticket_date = ""
    var ticket_deal_date = ""
    var ticket_deal_type = ""
    var ticket_no = ""
    var ticket_type = ""
    var ticket_volume = ""
    var ticketid = ""
    var tool = ""
    var trader = ""
    var trading_book = ""
    var underlying = ""
    
    //Arbitrage
    var trade_for = ""
    var mtm_value = ""
    
    //Restructure
    var ticket_deal_type_before = ""
    var counter_party_before = ""
    var underlying_before = ""
    var tool_before = ""
    var tenor_period_before = ""
    var price_before = ""
    var ticket_volume_before = ""
    var restructureAmount = ""
    
    var brief = ""
    
    init() {
        // do nothing
    }
}
