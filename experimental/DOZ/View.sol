pragma solidity ^0.4.19;


contract View is ProfileBase, Follow, String, Rank {


    function getProfileHandle(uint256 _id) public view returns(string) {
        require(exists(_id));
        return profiles[_id].handle;
    }

    function doesFollow(uint256 _initiatorId, uint256 _targetId) public view returns(uint256) {
        require(exists(_initiatorId) && exists(_targetId));
        return followStatus[keccak256(_initiatorId, _targetId, "follows")];
    }

    function isFollowedBy(uint256 _initiatorId, uint256 _targetId) public view returns(uint256) {
        require(exists(_initiatorId) && exists(_targetId));
        return followStatus[keccak256(_initiatorId, _targetId, "followedBy")];
    }

    function getProfileRank(uint256 _id) public view returns(uint256) {
        require(exists(_id));
        return profiles[_id].rank;
    }

    function getID(string _handle) public view returns(uint256) {
        uint256 idx = handleToId[keccak256(_handle)];
        require(exists(idx));
        return idx;
    }

    function isHandleRegistered(string _handle) public view returns(bool) {
        uint256 idx = handleToId[keccak256(_handle)];
        return exists(idx);
    }
}
