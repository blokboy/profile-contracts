pragma solidity ^0.4.19;


contract Verified is ProfileFactory {

    function regularVerification(uint48 _profileId) internal {
        profiles[_profileId].verifiedStatus["regular"] = true;
    }

    function vipVerification(uint48 _profileId) internal {
        profiles[_profileId].verifiedStatus["vip"] = true;
    }

    function transferVerification(string _tier, uint48 _initiatorId, uint48 _targetId) internal {
        profiles[_initiatorId].verifiedStatus[_tier] = false;
        profiles[_targetId].verifiedStatus[_tier] = true;
    }
}
