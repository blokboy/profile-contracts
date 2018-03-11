pragma solidity ^0.4.19;


contract DOZView is ProfileFactory {

    function getProfileName(uint48 _profileId) public view returns(string) {
        return profiles[_profileId].name;
    }

    function getProfileHandle(uint48 _profileId) public view returns(string) {
        return profiles[_profileId].handle;
    }

    function getProfileBio(uint48 _profileId) public view returns(string) {
        return profiles[_profileId].bio;
    }

    function getProfileMetadata(uint48 _profileId, string _metaKey, string _namespace) public view returns(string) {
        return profiles[_profileId].metadata[_namespace + ":" + _metaKey];
    }

    function getProfileFollowerCount(uint48 _profileId) public view returns(uint32) {
        return profiles[_profileId].followerCount;
    }

    function getProfileFollowingCount(uint48 _profileId) public view returns(uint32) {
        return profiles[_profileId].followingCount;
    }

    function followsProfile(uint48 _profileId, uint48 _followerId) public view returns(bool) {
        return profiles[_profileId].followsU[_followerId];
    }

    function profileFollows(uint48 _profileId, uint48 _followingId) public view returns(bool) {
        return profiles[_profileId].uFollow[_followingId];
    }

    function getVerifiedStatus(uint48 _profileId, string _tier) public view returns(bool) {
        return profiles[_profileId].verifiedStatus[_tier];
    }

    function getProfileDateCreated(uint48 _profileId) public view returns(uint64) {
        return profiles[_profileId].dateCreated;
    }
}
