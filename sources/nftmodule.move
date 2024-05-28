module suivents::NFTModule {
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use suivents::EventModule::{Event};

    public struct NFT has key, store {
        id: u64,
        owner: address,
        event_id: u64,
        checked_in: bool,
    }

    // Mint a new NFT
    public fun mint_nft(owner: address, event_id: u64, context: &mut TxContext): NFT {
        let nft_id = TxContext::generate_unique_id(context);
        NFT {
            id: nft_id,
            owner,
            event_id,
            checked_in: false,
        }
    }

    // Check-in with NFT
    public fun check_in_with_nft(nft: &mut NFT, context: &mut TxContext) {
        assert!(!nft.checked_in, "NFT already checked in");
        nft.checked_in = true;

        Event::emit(NFTCheckedIn { nft_id: nft.id });
    }

    // Whitelist and airdrop NFT tickets
    public fun airdrop_nfts(event: &mut Event, recipients: vector<address>, context: &mut TxContext) {
        let sender = TxContext::sender(context);
        assert!(sender == event.organizer, "Only organizer can airdrop NFTs");

        for recipient in &recipients {
            let nft = mint_nft(*recipient, event.id, context);
            transfer::transfer(nft, *recipient);
        }

        Event::emit(NFTAirdropped { event_id: event.id, recipients });
    }

    // Define event structures for emission
   public  struct NFTCheckedIn has drop {
        nft_id: u64,
    }

    public struct NFTAirdropped has drop {
        event_id: u64,
        recipients: vector<address>,
    }
}
