module Suivents::NFTModule {
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct NFT has key, store {
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
        nft.checked_in = true;
    }
}
