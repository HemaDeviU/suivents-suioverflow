# Suivents
Event Ticketing and Management on chain- built on Sui


Project Features of Suivents:
    - To Build an app(PWA) for listing Sui or Sui-related events (ex. Luma or eventbrite) utilizing dynamic NFTs
    - user signs up via zkLogin/wallet
    - at the event, at the reception desk, user checks-in on-chain using their NFT objects
    - user can share photos / videos taken from the event
    - a user can see another user’s history of events attended(confirm checked-ins) and filter for the ones they both attended

Here is how I have planned the flow. 

Anyone should be able to create an event (role: event organiser) by specifying the event name, start date and time, end date and time, timezone, location, priceofticket. Each event can be identified by a unique eventid. 
Any user should be able to see all the events listed and must be able to get register for the event, specifying their name and eventid. if the priceofticket is  greater than 0, then the user also pays the ticketprice which goes to the organiser's wallet address.
The event organiser should be able to see the list of users who have registered, if it's a paid event(priceofticket >0) .  the event organiser should be able to see the list of users who have registered and paid for the ticket to event if it is paid. lets call the registered users as guests.
.the event organisers can whitelist for the guests addresses for  dynamic nft ticket object. 
The event organiser now airdrops the dynamic nft ticket objects for the whitelisted guests.
at the event, The guests should be able to check-in onchain using using their NFT objects.
The NFT should change dynamically change after checking in. 
 A user can share photos / videos taken from the event.
a user can see another user’s history of events attended(confirm checked-ins) and filter for the ones they both attended.
