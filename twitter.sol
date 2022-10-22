// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Twitter {
    struct Tweet {
        uint tweetId;
        address author;
        string content;
        uint createdAt;
    }

    struct User {
        address wallet;
        string name;
        uint[] userTweets;
    }

    mapping(address => User) public users;
    mapping(uint => Tweet) public tweets;
    uint256 public nextTweetId;
    
    address[] public addresses_users;
    uint max_user_tweets = 10;

    function registerAccount(string calldata _name) external {
        require( keccak256(abi.encodePacked((_name))) != keccak256(abi.encodePacked((""))),
                "Name cannot be an empty string"
                );

        uint256[] memory _userTweets = new uint256[](0);
        addresses_users.push(msg.sender);
        users[msg.sender] = User(msg.sender,_name,_userTweets);
    }

    function postTweet(string calldata _content) external accountExists(msg.sender) {     
        
        tweets[nextTweetId] = Tweet(nextTweetId,
                                     msg.sender,
                                     _content,
                                     block.timestamp
                                     );        
        nextTweetId += 1;
    }

    function readTweets(address _user) view external returns(Tweet[] memory) {
                
        uint[] memory userTweetIds = new uint[](max_user_tweets);
        Tweet[] memory userTweets = new Tweet[](max_user_tweets);

        uint idx;
        for (uint8 i=0; i<= nextTweetId -1; i++){
            if(tweets[i].author == _user){
                userTweetIds[idx] = i;
                idx+=1;
            }
        }
        
        for (uint8 i=0; i<= userTweetIds.length -1; i++){
            userTweets[i] = tweets[userTweetIds[i]];
        }
        
        return userTweets;
    }

    modifier accountExists(address _user) {
        
        bool boolean = false;

        for (uint8 i=0; i<= addresses_users.length -1; i++){
            if (addresses_users[i] == _user)
            {
                boolean = true;
            }  
        }

        require(boolean == true,
                "This wallet does not belong to any account."
                );
        _;
    }

}
