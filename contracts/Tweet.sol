// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract Tweet {
    address owner;
    struct UserTweet{
        uint256 id;
        address author;
        string message;
        uint256 timestamp;
        uint256 like;
    }

    mapping(address => UserTweet[]) private tweets; 
    uint152 public MAX_TWEET_LEN = 280;

    event TweetCreated(uint256 id, address author, string context, uint256 timestamp);
    event TweetLike(address liker, address author, uint256 id, uint256 newLike);
    event TweetUnLike(address unliker, address author, uint256 id, uint256 newLike);

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner{
        require(msg.sender == owner, "You are not the owner.");
        _;
    }

    modifier tweetExists(address _author, uint256 _id) {
        require(_id < tweets[_author].length && tweets[_author][_id].id == _id, "Tweet does not exist");
        _;
    }

    modifier tweetLengthValid(string memory _tweet) {
        require(bytes(_tweet).length <= MAX_TWEET_LEN, "Tweet exceeds maximum length");
        _;
    }

    function changeTweetMaxLength(uint152 _len) public OnlyOwner {
        MAX_TWEET_LEN = _len;
    }

    function setTweet(string memory _tweet) public tweetLengthValid(_tweet) {
        UserTweet memory newTweet = UserTweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            message: _tweet,
            timestamp: block.timestamp,
            like: 0
        });
        tweets[msg.sender].push(newTweet);
        emit TweetCreated(newTweet.id, newTweet.author, _tweet, newTweet.timestamp);
    }

    function likeTweet(address _author, uint256 _id) external tweetExists(_author, _id) {
        tweets[_author][_id].like++;
        emit TweetLike(msg.sender, _author, _id, tweets[_author][_id].like);
    }

    function unlikeTweet(address _author, uint256 _id) external tweetExists(_author, _id) {
        require(tweets[_author][_id].like > 0, "Like is already 0");
        tweets[_author][_id].like--;
        emit TweetUnLike(msg.sender, _author, _id, tweets[_author][_id].like);
    }

    function getTweetById(uint256 _id) public view returns(UserTweet memory) {
        return tweets[msg.sender][_id];
    }

    function getTweets() public view returns(UserTweet[] memory) {
        return tweets[msg.sender];
    }
}