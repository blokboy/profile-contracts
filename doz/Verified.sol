pragma solidity ^0.4.19;

import "./ProfileFactory.sol";


contract Verified is ProfileFactory {

    function verification(uint256 _tier, uint256 _profileId) internal {
        verifiedStatus[_profileId][_tier] = true;
    }

    function _transferVerification(uint256 _tier, uint256 _initiatorId, uint256 _targetId) internal {
        verifiedStatus[_initiatorId][_tier] = false;
        verifiedStatus[_targetId][_tier] = true;
    }
}
