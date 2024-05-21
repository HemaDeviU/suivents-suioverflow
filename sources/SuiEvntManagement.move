/*
/// Module: suivents
module suivents::suivents {

}
*/
module SuiEvntManagement::SuiEvntManagement {

    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct SuiEvnt has key, store {
        id: UID,
        name: vector<u8>,
        description: vector<u8>,
        date: u64,
        organizer: address,
        whitelist: vector<address>,
    }

    public entry fun create_suievnt(
        name: vector<u8>,
        description: vector<u8>,
        date: u64,
        organizer: address,
        whitelist: vector<address>,
        ctx: &mut TxContext
    ): SuiEvnt {
        SuiEvnt {
            id: object::new(ctx),
            name,
            description,
            date,
            organizer,
            whitelist,
        }
    }

    public fun get_suievnt(suievnt: &SuiEvnt): &SuiEvnt {
        suievnt
    }
}
