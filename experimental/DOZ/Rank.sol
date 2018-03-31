pragma solidity ^0.4.19;


contract Rank is ProfileBase {

    mapping (uint256 => uint256) public rankToPrice; // the price associate with each rank

    function _rankUp(uint256 _rank, uint256 _id) internal {
        profiles[_id].rank = _rank;
    }

    function _transferRank(uint256 _rank, uint256 _initiatorId, uint256 _targetId) internal {
        profiles[_initiatorId].rank = profiles[_targetId].rank;
        profiles[_targetId].rank = _rank;
    }
}
