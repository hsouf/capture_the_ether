pragma solidity ^0.4.21;



contract c {
    
    
    address guess_addr  = 0x514E3822BFC7B965B3445fF17a52Ba3C279FE545;

    function myguess() public returns(bytes32 name) {
        name=bytes32(2**256-0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6);
      
    }
}

