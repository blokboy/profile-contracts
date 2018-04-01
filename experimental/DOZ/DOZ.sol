pragma solidity ^0.4.19;


contract DOZ is Ownable, View, Follow, String, Meta, Rank {

    /* MISSING
    Ranking has been built in, but I'm still missing verification and reputation
    I make it so that anybody can rankUp a profile but then there's no incentive for Dapps to push for rankUp
    Following and unfollowing is still expensive, I need to track who follows who and somehow reduce storage
    */

    // the price of a Profile
    uint256 public price;

    event ProfileCreated(string indexed _handle, uint256 indexed _id);
    event ProfileDeleted(string indexed _handle, uint256 indexed _id);
    event HandleChange(uint256 indexed _id, string indexed _newHandle);
    event NewFollow(uint256 indexed _followingId, uint256 indexed _followedId);
    event NewUnfollow(uint256 indexed _unfollowingId, uint256 indexed _unfollowedId);
    event NewRank(uint256 indexed _rank, uint256 indexed _id);
    event RankTransfered(uint256 indexed _rank, uint256 indexed _initiatorId, uint256 indexed _targetId);
    event MetadataChanged(string indexed _key, string indexed _value, uint256 indexed _id);

    function DOZ(uint256 _price) public {
        price = _price;
    }

    function createProfile(string _handle) public payable {
        require(msg.value >= price); // gotta pay the price
        require(!isHandleRegistered(_handle)); // handles can't be registered
        ProfileCreated(_handle, id);
        _createProfile(string _handle);
    }

    function deleteProfile(uint256 _id, string _handle) public onlyOwnerOf(_id) mustExist(_id) {
        _deleteProfile(_id, _handle);
        ProfileDeleted(_handle, _id);
    }

    // STRING FUNCTIONS
    function changeHandle(string _newHandle, uint256 _id) public onlyOwnerOf(_id) mustExist(_id) {
        require(!isHandleRegistered(_newHandle));
        _changeHandle(_newHandle, _id);
        HandleChange(_id, _newHandle);
    }
    // STRING FUNCTIONS END

    // META FUNCTIONS
    function editMetadata(string metaKey, string metaValue, uint256 _id) public onlyOwnerOf(_id) mustExist(_id) {
        MetadataChanged(metaKey, metaValue, _id);
    }

    function removeMetadata(string metaKey, uint256 _id) public onlyOwnerOf(_id) mustExist(_id) {
        MetadataChanged(metaKey, "", _id);
    }
    // META FUNCTIONS END

    // FOLLOW FUNCTIONS
    // Follow functions must check if profiles exist in the first place
    function follow(uint256 _initiatorId, uint256 _targetId) public onlyOwnerOf(_initiatorId) mustExist(_initiatorId) mustExist(_targetId) {
        require(_initiatorId != _targetId); // make sure we're not following ourselves
        NewFollow(_initiatorId, _targetId);
    }

    function unfollow(uint256 _initiatorId, uint256 _targetId) public onlyOwnerOf(_initiatorId) mustExist(_initiatorId) mustExist(_targetId) {
        require(_initiatorId != _targetId); // make sure we're not unfollowing ourselves
        NewUnfollow(_initiatorId, _targetId);
    }
    // FOLLOW FUNCTIONS END

    // RANK FUNCTIONS
    function setRank(uint256 _newRank, uint256 _price) public onlyOwner {
        rankToPrice[_newRank] = _price;
    }

    function vetoRankUp(uint256 _rank, uint256 _id) public onlyOwner mustExist(_id) {
        require(rankToPrice[_rank] != 0);
        _rankUp(_rank, _id);
    }

    function deleteRank(uint256 _rank) public onlyOwner {
        delete rankToPrice[_rank];
    }

    function rankUp(uint256 _rank, uint256 _id) public payable mustExist(_id) {
        require(rankToPrice[_rank] != 0);
        require(msg.value >= rankToPrice[_rank]);
        _rankUp(_rank, _id);
        NewRank(_rank, _id);
    }

    function transferRank(uint256 _rank, uint256 _initiatorId, uint256 _targetId) public onlyOwnerOf(_initiatorId) mustExist(_initiatorId) mustExist(_targetId) {
        require(profiles[_initiatorId].rank == _rank); // your initial profile needs to be verified
        require(profiles[_targetId].rank != _rank); // your final profile can't be verified
        _transferRank(_rank, _initiatorId, _targetId);
        RankTransfered(_rank, _initiatorId, _targetId);
    }

    function changePrice(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
    }

    // Withdraw the funds of the account from fees received by charging for profiles
    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

}
