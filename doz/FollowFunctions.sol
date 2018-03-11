pragma solidity ^0.4.19;


contract FollowFunctions is ProfileFactory {

    function newFollow(uint48 _initiatorId, uint48 _targetId) internal {
      /* Triggered when somebody follows another person
      followIncrease is used when deferred updating is enabled
      A following is added to the initiator and a follower is added to the target */
        profiles[_targetId].followsU[_initiatorId] = true;
        profiles[_initiatorId].uFollow[_targetId] = true;

        // And now for the follower counts
        profiles[_initiatorId].followingCount = profiles[_initiatorId].followingCount.add(1);
        profiles[_targetId].followerCount = profiles[_targetId].followerCount.add(1);
    }

    function newUnfollow(uint48 _initiatorId, uint48 _targetId) internal {
  /* Triggered when somebody unfollows another person
  A following is substracted from the initiator and a follower is substracted from the target */
        profiles[_targetId].followsU[_initiatorId] = false;
        profiles[_initiatorId].uFollow[_targetId] = false;

        // And now for the follower counts
        profiles[_initiatorId].followingCount = profiles[_initiatorId].followingCount.sub(1);
        profiles[_targetId].followerCount = profiles[_targetId].followerCount.sub(1);
    }
}
