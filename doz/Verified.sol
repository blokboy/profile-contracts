pragma solidity ^0.4.19;

import "./ProfileFactory.sol";


contract Verified is ProfileFactory {

    function verification(uint8 _tier, uint256 _profileId) internal {
        verifiedStatus[_profileId] = _tier;
    }

    function _transferVerification(uint8 _tier, uint256 _initiatorId, uint256 _targetId) internal {
        verifiedStatus[_initiatorId] = verifiedStatus[_targetId];
        verifiedStatus[_targetId] = _tier;
    }
}
