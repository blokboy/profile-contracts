pragma solidity ^0.4.19;

import "./ProfileFactory.sol";


contract FollowFunctions is ProfileFactory {

    function _follow(uint256 _initiatorId, uint256 _targetId) internal {
      /* Triggered when somebody follows another person
      followIncrease is used when deferred updating is enabled
      A following is added to the initiator and a follower is added to the target */
        followsU[_targetId][_initiatorId] = true;
        uFollow[_initiatorId][_targetId] = true;

        // And now for the follower counts
        profiles[_initiatorId].followingCount = profiles[_initiatorId].followingCount.add(1);
        profiles[_targetId].followerCount = profiles[_targetId].followerCount.add(1);
    }

    function _unfollow(uint256 _initiatorId, uint256 _targetId) internal {
      /* Triggered when somebody unfollows another person
      A following is substracted from the initiator and a follower is substracted from the target */
        followsU[_targetId][_initiatorId] = false;
        uFollow[_initiatorId][_targetId] = false;

        // And now for the follower counts
        profiles[_initiatorId].followingCount = profiles[_initiatorId].followingCount.sub(1);
        profiles[_targetId].followerCount = profiles[_targetId].followerCount.sub(1);
    }
}
