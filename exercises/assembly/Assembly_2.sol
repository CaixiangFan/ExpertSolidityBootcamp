// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract Add {
    function addAssembly(uint256 x, uint256 y) public pure returns (uint256) {
        // Intermediate variables can't communicate between  assembly blocks
        // But they can be written to memory in one block
        // and retrieved in another.
        // Fix this code using memory to store the result between the blocks
        // and return the result from the second block
        assembly {
            let result := add(x, y)
            let ptr := mload(0x40)
            let free_mem := add(ptr, 0x20)
            mstore(result, free_mem)
        }

        assembly {
            let ptr := mload(0x40)
            let free_mem := add(ptr, 0x20)
            return(free_mem, 0x20)
        }
    }
}
