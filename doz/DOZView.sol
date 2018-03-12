pragma solidity ^0.4.19;

import "./ProfileFactory.sol";


contract DOZView is ProfileFactory {

    function getProfileName(uint256 _profileId) public view returns(string) {
        return profiles[_profileId].name;
    }

    function getProfileHandle(uint256 _profileId) public view returns(string) {
        return profiles[_profileId].handle;
    }

    function getProfileBio(uint256 _profileId) public view returns(string) {
        return profiles[_profileId].bio;
    }

    function getProfileMetadata(uint256 _profileId, string _metaKey, string _space) public view returns(string) {
        return metadata[_profileId][_space][_metaKey];
    }

    function getProfileFollowerCount(uint256 _profileId) public view returns(uint256) {
        return profiles[_profileId].followerCount;
    }

    function getProfileFollowingCount(uint256 _profileId) public view returns(uint256) {
        return profiles[_profileId].followingCount;
    }

    function followsProfile(uint256 _profileId, uint256 _followerId) public view returns(bool) {
        return followsU[_profileId][_followerId];
    }

    function profileFollows(uint256 _profileId, uint256 _followingId) public view returns(bool) {
        return uFollow[_profileId][_followingId];
    }

    function getVerifiedStatus(uint256 _profileId, uint256 _tier) public view returns(bool) {
        return verifiedStatus[_profileId][_tier];
    }

    function getProfileDateCreated(uint256 _profileId) public view returns(uint64) {
        return profiles[_profileId].dateCreated;
    }
}
