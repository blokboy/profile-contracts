pragma solidity ^0.4.19;


contract Follow is ProfileBase {

    /**
    * followStatus stores a bytes32 hash of whether an id follows and ID or if it's followed by an ID
    * if it's to see if an id follows another id the mapping stores it like this
    *   followStatus[keccak256(_id1, _id2, "follows")] = true;
    * if it's to see if an id is followed by another id it is stores like this
    *   followStatus[keccak256(_id1, _id2, "followedBy")] = true;
    */
    mapping (bytes32 => bool) internal followStatus;

    /**
    * @dev Guarantees msg.sender is owner of the given token
    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
    */
    modifier mustFollow(uint256 _initiatorId, uint256 _targetId) {
        require(doesFollow(_initiatorId, _targetId));
        _;
    }

    /**
    * @dev Guarantees msg.sender is owner of the given token
    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
    */
    modifier mustNotFollow(uint256 _initiatorId, uint256 _targetId) {
        require(!doesFollow(_initiatorId, _targetId));
        _;
    }

    function _follow(uint256 _initiatorId, uint256 _targetId) internal {
        followStatus[keccak256(_initiatorId, _targetId, "follows")] = true;
        followStatus[keccak256(_targetId, _initiatorId, "followedBy")] = true;
    }

    function _unfollow(uint256 _initiatorId, uint256 _targetId) internal {
        followStatus[keccak256(_initiatorId, _targetId, "follows")] = false;
        followStatus[keccak256(_targetId, _initiatorId, "followedBy")] = false;
    }
}
