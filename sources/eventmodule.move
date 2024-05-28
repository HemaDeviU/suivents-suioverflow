module Suivents::EventModule {
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::event::Event;

    struct Event has key, store {
        id: u64,
        name: vector<u8>,
        start_date: u64,
        end_date: u64,
        timezone: vector<u8>,
        location: vector<u8>,
        price_of_ticket: u64,
        organizer: address,
        registered_users: vector<address>,
        checked_in_users: vector<address>,
    }

    struct User has key, store {
        id: address,
        name: vector<u8>,
        event_history: vector<u64>,
    }

    // Create a new event
    public fun create_event(
        name: vector<u8>, 
        start_date: u64, 
        end_date: u64, 
        timezone: vector<u8>, 
        location: vector<u8>, 
        price_of_ticket: u64, 
        context: &mut TxContext
    ): Event {
        let sender = TxContext::sender(context);
        let event_id = TxContext::generate_unique_id(context);
        let event = Event {
            id: event_id,
            name,
            start_date,
            end_date,
            timezone,
            location,
            price_of_ticket,
            organizer: sender,
            registered_users: vector::empty(),
            checked_in_users: vector::empty(),
        };

        Event::emit(EventCreated { event_id });
        event
    }

    // Register for an event
    public fun register_for_event(event: &mut Event, user: &mut User, context: &mut TxContext) {
        let sender = TxContext::sender(context);
        assert!(!vector::contains(&event.registered_users, &sender), "User already registered");
        if event.price_of_ticket > 0 {
            transfer::transfer(event.price_of_ticket, sender, event.organizer);
        }
        vector::push_back(&mut event.registered_users, sender);
        vector::push_back(&mut user.event_history, event.id);

        Event::emit(EventRegistered { event_id: event.id, user: sender });
    }

    // Check-in at the event
    public fun check_in(event: &mut Event, user: address, context: &mut TxContext) {
        assert!(vector::contains(&event.registered_users, &user), "User not registered");
        assert!(!vector::contains(&event.checked_in_users, &user), "User already checked in");
        vector::push_back(&mut event.checked_in_users, user);

        Event::emit(EventCheckedIn { event_id: event.id, user });
    }

   
    // Get registered users for an event
    public fun get_registered_users(event: &Event, context: &TxContext): vector<address> {
        assert!(TxContext::sender(context) == event.organizer, "Only organizer can view registered users");
        event.registered_users
    }

    // Get paid users for an event
    public fun get_paid_users(event: &Event, context: &TxContext): vector<address> {
        assert!(TxContext::sender(context) == event.organizer, "Only organizer can view paid users");
        if event.price_of_ticket > 0 {
            event.registered_users
        } else {
            vector::empty()
        }
    }

    // Define event structures for emission
    struct EventCreated has drop {
        event_id: u64,
    }

    struct EventRegistered has drop {
        event_id: u64,
        user: address,
    }

    struct EventCheckedIn has drop {
        event_id: u64,
        user: address,
    }
}
