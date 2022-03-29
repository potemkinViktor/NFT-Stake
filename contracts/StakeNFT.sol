//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";

contract NftStaker {
    IERC1155 public parentNFT;

    address public contractNFT;

    struct Stake {
        uint256 tokenId;
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;

    mapping(address => uint256) public stakingTime;    

    constructor() {
        parentNFT = IERC1155(contractNFT); // Changing for any NFT contract
    }

    function stake(uint256 _tokenId, uint256 _amount) public {
        stakes[msg.sender] = Stake(_tokenId, _amount, block.timestamp); 
        parentNFT.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, "0x00");
    } 

    function unstake() public {
        parentNFT.safeTransferFrom(address(this), msg.sender, stakes[msg.sender].tokenId, stakes[msg.sender].amount, "0x00");
        stakingTime[msg.sender] += (block.timestamp - stakes[msg.sender].timestamp);
        delete stakes[msg.sender];
    }      

     function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

}