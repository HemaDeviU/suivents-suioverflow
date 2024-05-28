module Suivents::UserModule {
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct UserProfile has key, store {
        id: address,
        name: vector<u8>,
        event_history: vector<u64>,
    }

    // Create a new user profile
    public fun create_user(name: vector<u8>, context: &mut TxContext): UserProfile {
        let user_id = TxContext::sender(context);
        UserProfile {
            id: user_id,
            name,
            event_history: vector::empty(),
        }
    }

    // Add event to user history
    public fun add_event_to_history(user: &mut UserProfile, event_id: u64) {
        vector::push_back(&mut user.event_history, event_id);
    }
}
