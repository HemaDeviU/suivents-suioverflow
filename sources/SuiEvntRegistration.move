module SuiEvntUserRegistration ::SuiEvntUserRegistration {

    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    struct User has key, store {
        id: UID,
        address: address,
        registered_suievnts: vector<UID>,
    }

    struct Registration has key, store {
        id: UID,
        suievnt_id: UID,
        user: address,
        paid: bool,
    }

    public entry fun register_user(
        user: &mut User,
        suievnt_id: UID,
        paid: bool,
        ctx: &mut TxContext
    ) {
        let registration = Registration { id: object::new(ctx), suievnt_id, user: user.address, paid };
        user.registered_suievnts.push(suievnt_id);
        // Emit event or store registration details
    }

    public fun get_registered_suievnts(user: &User): &vector<UID> {
        &user.registered_suievnts
    }

}
