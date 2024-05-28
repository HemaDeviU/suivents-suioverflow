module Suivents::UserModule {
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

    // Update user profile
    public fun update_user(user: &mut UserProfile, name: vector<u8>, context: &mut TxContext) {
        let sender = TxContext::sender(context);
        assert!(user.id == sender, "Only the user can update their profile");
        user.name = name;

        Event::emit(UserProfileUpdated { user_id: user.id, name });
    }

    // Add event to user history
    public fun add_event_to_history(user: &mut UserProfile, event_id: u64) {
        vector::push_back(&mut user.event_history, event_id);
    }

    // Retrieve user profile
    public fun get_user_profile(user: &UserProfile): (vector<u8>, vector<u64>) {
        (user.name, user.event_history)
    }

    // Define event structures for emission
    struct UserProfileUpdated has drop {
        user_id: address,
        name: vector<u8>,
    }
}
