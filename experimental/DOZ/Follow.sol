pragma solidity ^0.4.19;


contract Follow is ProfileBase {

    function _follow(uint256 _initiatorId, uint256 _targetId) internal {
        // The follower/following counts are adjusted
        profiles[_initiatorId].followings++;
        profiles[_targetId].followers++;
    }

    function _unfollow(uint256 _initiatorId, uint256 _targetId) internal {
        // The follower/following counts are adjusted
        profiles[_initiatorId].followings--;
        profiles[_targetId].followers--;
    }
}
