//
//  MyConfigs.swift
//  PocketPay
//

import UIKit

struct MyConfigs {
    static let appName = "ComX"
    static let serviceTimeout = 60.0
    
    static let MIN_PASSWORD_LENGTH = 8      // tailor:disable
    static let MAX_PASSWORD_LENGTH = 20     // tailor:disable
    static let PIN_LENGTH = 4               // tailor:disable
}

struct MyErrorCode {
    static let invalidUserStatus = "200006"
    static let deviceIdMismatch = "200007"
    static let sessionExpired = "200009"
    static let forceChangePassword = "200020"
    static let forceChangePin = "200021"
    static let invalidPin = "300006"
    static let forceUpdateApp = "200023"
}

struct MyMessage {
    static let noInternet = "No Internet Connection"
    static let failedToCreateRequestBody = "Failed to create request"
    static let failedToParseReponseBody = "Unexpected response from server"
    static let noNetworkConntection = "No Internet Connection"
}

struct System {
    static let Bunker = "BUNKER"
    static let Chartering = "CHARTERING"
    static let CountTxn = "CON_TXN"
    static let Dropdown = "DROPDOWN"
    static let Message = "MESSAGE"
    static let Crude = "CRUDE_P"
    static let VCool = "VCOOL"
    static let Paf = "PAF"
    static let Product = "PRODUCT"
    static let Demurrage = "DAF"
    static let Hedge_tckt = "HEDG_TCKT"
    static let Hedge_sett = "HEDG_SETT"
    static let Crude_O = "CRUDE_O"
    static let All_My_Task = "ALL"
    static let Hedge_Bot = "HEDG_BOT"
    static let Advance_loading = "ADVANCE_LOADING"
    static let Final_contract = "CONTRACT_DOCUMENT"
}

struct Status {
    static let Waiting = "WAITING CERTIFIED"
    static let Approved = "APPROVED"
    static let cancel = "CANCELED"
}


enum WorkMode: String {
    case DEV
    case UAT
    case PRD
    case PPRD
    
    func getUrl() -> String {
        
        switch self {
        case .DEV:
            //return "http://tsr-dcpai-app.thaioil.localnet/PAF"
            //return "http://tsr-dcpai-app.thaioil.localnet/DAF"
            //return "http://tsr-dcpai-app.thaioil.localnet/CHR"
            return "https://cpai.thaioilgroup.com/ws_mobile_dev"
//            return "https://cpai.thaioilgroup.com/ws_mobile_qas"
        case .UAT:
            return "https://cpai.thaioilgroup.com/ws_mobile_qas"
            //return "https://cpai.thaioilgroup.com/ws_mobile_dev" //vcool
            
        case .PRD:
            return "https://cpai.thaioilgroup.com/ws_mobile_prod"
        case .PPRD:
            return "https://cpai.thaioilgroup.com/ws_mobile_preprod"
            //return "https://tsr-dmz-app01.thaioil.localnet/ws_mobile_preprod"
            
        }
    }
    
    func getPublicKey() -> String {
        switch self {
        case .DEV:
            return "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAMc1C9dml8sNUEnd6V+5whIoMe+nBJbyD0/cTjGmmgdSSZIHhjBsGd7XTbqvO90jefVqjfjYtQ6FBOZRo9rogHsCAwEAAQ=="
        case .UAT:
            return "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAMc1C9dml8sNUEnd6V+5whIoMe+nBJbyD0/cTjGmmgdSSZIHhjBsGd7XTbqvO90jefVqjfjYtQ6FBOZRo9rogHsCAwEAAQ=="
        case .PRD:
            return "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAMc1C9dml8sNUEnd6V+5whIoMe+nBJbyD0/cTjGmmgdSSZIHhjBsGd7XTbqvO90jefVqjfjYtQ6FBOZRo9rogHsCAwEAAQ=="
        case .PPRD:
            return "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAMc1C9dml8sNUEnd6V+5whIoMe+nBJbyD0/cTjGmmgdSSZIHhjBsGd7XTbqvO90jefVqjfjYtQ6FBOZRo9rogHsCAwEAAQ=="
        }
    }
    
    func getPrivateKey() -> String {
        switch self {
        case WorkMode.DEV:
            return "MIIBUwIBADANBgkqhkiG9w0BAQEFAASCAT0wggE5AgEAAkEAxzUL12aXyw1QSd3pX7nCEigx76cElvIPT9xOMaaaB1JJkgeGMGwZ3tdNuq873SN59WqN+Ni1DoUE5lGj2uiAewIDAQABAj8Mc0RKMh9KkYpzE2uCkBmRCPIWCFpBFN/gHeTFNaRq0J2FRQROXrym124yGAxjQJRl15nrgD2EOKfS6LgAToECIQDtRU9UzQXjUiaRFzKcjkbSzF20/ymZ989zcLfvXw5ZdwIhANbuj5gtNYYzb2wLGLeaDSzCTNzIDIrPUtC8kQXrchIdAiBpjoAwldWcwBtwSQW3KITRmyHFOA9l9B1Smj76OyvDGQIgeOW33+GOOe60vhF/1cbRoluo4Iemhm4YJ1HqQWouwAECIQDSxGNa4qIFyynPF4vwCXekkntBS8J5o/LBLv8xCYvlkA=="
        case WorkMode.UAT:
            return "MIIBUwIBADANBgkqhkiG9w0BAQEFAASCAT0wggE5AgEAAkEAxzUL12aXyw1QSd3pX7nCEigx76cElvIPT9xOMaaaB1JJkgeGMGwZ3tdNuq873SN59WqN+Ni1DoUE5lGj2uiAewIDAQABAj8Mc0RKMh9KkYpzE2uCkBmRCPIWCFpBFN/gHeTFNaRq0J2FRQROXrym124yGAxjQJRl15nrgD2EOKfS6LgAToECIQDtRU9UzQXjUiaRFzKcjkbSzF20/ymZ989zcLfvXw5ZdwIhANbuj5gtNYYzb2wLGLeaDSzCTNzIDIrPUtC8kQXrchIdAiBpjoAwldWcwBtwSQW3KITRmyHFOA9l9B1Smj76OyvDGQIgeOW33+GOOe60vhF/1cbRoluo4Iemhm4YJ1HqQWouwAECIQDSxGNa4qIFyynPF4vwCXekkntBS8J5o/LBLv8xCYvlkA=="
        case WorkMode.PRD:
            return "MIIBUwIBADANBgkqhkiG9w0BAQEFAASCAT0wggE5AgEAAkEAxzUL12aXyw1QSd3pX7nCEigx76cElvIPT9xOMaaaB1JJkgeGMGwZ3tdNuq873SN59WqN+Ni1DoUE5lGj2uiAewIDAQABAj8Mc0RKMh9KkYpzE2uCkBmRCPIWCFpBFN/gHeTFNaRq0J2FRQROXrym124yGAxjQJRl15nrgD2EOKfS6LgAToECIQDtRU9UzQXjUiaRFzKcjkbSzF20/ymZ989zcLfvXw5ZdwIhANbuj5gtNYYzb2wLGLeaDSzCTNzIDIrPUtC8kQXrchIdAiBpjoAwldWcwBtwSQW3KITRmyHFOA9l9B1Smj76OyvDGQIgeOW33+GOOe60vhF/1cbRoluo4Iemhm4YJ1HqQWouwAECIQDSxGNa4qIFyynPF4vwCXekkntBS8J5o/LBLv8xCYvlkA=="
        case .PPRD:
            return "MIIBUwIBADANBgkqhkiG9w0BAQEFAASCAT0wggE5AgEAAkEAxzUL12aXyw1QSd3pX7nCEigx76cElvIPT9xOMaaaB1JJkgeGMGwZ3tdNuq873SN59WqN+Ni1DoUE5lGj2uiAewIDAQABAj8Mc0RKMh9KkYpzE2uCkBmRCPIWCFpBFN/gHeTFNaRq0J2FRQROXrym124yGAxjQJRl15nrgD2EOKfS6LgAToECIQDtRU9UzQXjUiaRFzKcjkbSzF20/ymZ989zcLfvXw5ZdwIhANbuj5gtNYYzb2wLGLeaDSzCTNzIDIrPUtC8kQXrchIdAiBpjoAwldWcwBtwSQW3KITRmyHFOA9l9B1Smj76OyvDGQIgeOW33+GOOe60vhF/1cbRoluo4Iemhm4YJ1HqQWouwAECIQDSxGNa4qIFyynPF4vwCXekkntBS8J5o/LBLv8xCYvlkA=="
        }
    }
   
}
