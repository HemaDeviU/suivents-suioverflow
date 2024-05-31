module suivents::suivent {
    use sui::balance::Balance;
    use sui::coin::{Self,Coin};
    use std::string::String;
    use sui::event;
    use sui::object::{Self,UID};
    use sui::tx_context::TxContext;
   // use sui::nft::NFT;


    // Struct to hold event details
    public struct SEvent has key, store {
        id: UID,
        organiser: address,
        title: String,
        start_time: u64,
        end_time: u64,
        timezone: String,
        location: String,
        price_of_ticket: u64,
        registered_guests: vector<Guest>,
        checked_in_guests: vector<Guest>,
    }

    // Struct to hold user details
    public struct User has key, store {
        id: UID,
        address: address,
        name: String,
        event_history: vector<UID>,
    }

    // Struct to hold guest details
    public struct Guest has key, store {
        id: UID,
        user: User,
        event_id: UID,
        has_checked_in: bool,
        //nft_ticket: NFT,
    }
    //event struct
    public struct CreatedSEvent has copy, drop {
        organiser: address,
        title: String,
         start_time: u64,
        end_time: u64,
        timezone: String,
        location: String,
        price_of_ticket: u64,
    }

    // Function to create a new event
    public fun create_event(
        organiser: address,
        title: String,
        start_time: u64,
        end_time: u64,
        timezone: String,
        location: String,
        price_of_ticket: u64,
        ctx: &mut TxContext
    ) {
       //let event_id = object::new<SEvent>(ctx);
        let _created_sevent = SEvent {
            id: object::new(ctx),
            organiser,
            title,
            start_time,
            end_time,
            timezone,
            location,
            price_of_ticket,
            registered_guests: vector::empty<Guest>(),
            checked_in_guests: vector::empty<Guest>(),
        };
         event::emit(CreatedSEvent {
           // id: object::id(&created_event),
            organiser: tx_context::sender(ctx),
            title : title,
            start_time : start_time,
            end_time : end_time,
            timezone:timezone,
            location: location,
            price_of_ticket:price_of_ticket,
        });
   
    }

    // Function to register for an event
   public fun register_for_event(
        user: &mut User,
        event_id: UID,
        name: String,
        payment: Balance<Coin<u64>>,
        ctx: &mut TxContext
    ) {
        let event = borrow_global_mut<SEvent>(event_id);
        let user_address = user.address;
        assert!(!vector::contains(&event.registered_guests, user),1);
        //1 is error code for "user already registered"
        if (event.price_of_ticket > 0) {
            assert!(balance::value(payment) >= event.price_of_ticket,2);
            //2 is error code for "insufficient funds"
            // Transfer payment to organiser
            coin::transfer(payment, event.organiser);
        }
        
    let guest_id = object::new<Guest>(ctx);
    let guest = Guest {
            id: guest_id,
            user: *user,
            /*user: User {
                id: object::new(),
                address: user.address,
                name,
                event_history: vector::empty<UID>(),
            },*/
            event_id,
            has_checked_in: false,
            //nft_ticket: nft::create("Ticket", "Dynamic NFT Ticket", ""),
        };
        
        vector::push_back(&mut event.registered_guests, guest);
        vector::push_back(&mut user.event_history, event_id);
    }
    
    // Function to whitelist guests
   /** public fun whitelist_guests(event_id: UID, guest_addresses: vector<address>) {
        let event = borrow_global_mut<Event>(event_id);
        for address in guest_addresses {
            let user = borrow_global<User>(address);
            assert!(vector::contains(&event.registered_guests, user), "User not registered");
            // Whitelist logic goes here
        }
    }

    // Function to airdrop NFT tickets
    public fun airdrop_nft_tickets(event_id: UID) {
        let event = borrow_global_mut<Event>(event_id);
        for guest in &mut event.registered_guests {
            // Logic to airdrop NFT tickets to whitelisted guests
            // Update guest's NFT ticket
            guest.nft_ticket = nft::create("Ticket", "Dynamic NFT Ticket", "");
        }
    }

    // Function to check in using NFT tickets
    public fun check_in(event_id: UID, user: address, nft_ticket: NFT) {
        let event = borrow_global_mut<Event>(event_id);
        for guest in &mut event.registered_guests {
            if guest.user.address == user && guest.nft_ticket == nft_ticket {
                guest.has_checked_in = true;
                // Logic to dynamically change NFT after check-in
                guest.nft_ticket = nft::create("Checked-In Ticket", "Dynamic NFT Ticket", "");
                vector::push_back(&mut event.checked_in_guests, guest);
            }
        }
    } */
}
