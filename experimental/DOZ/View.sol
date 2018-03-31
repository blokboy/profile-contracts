pragma solidity ^0.4.19;


contract View is ProfileBase {


    function getProfileHandle(uint256 _id) public view returns(string) {
        require(exists(_id));
        return profiles[_id].handle;
    }

    function getProfileFollowerCount(uint256 _id) public view returns(uint256) {
        require(exists(_id));
        return profiles[_id].followers;
    }

    function getProfileFollowingCount(uint256 _id) public view returns(uint256) {
        require(exists(_id));
        return profiles[_id].following;
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
