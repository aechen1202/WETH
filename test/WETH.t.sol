// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {WETH} from "../src/WETH.sol";
import "forge-std/console.sol"; 

contract WETHTest is Test {
    WETH public Weth;
    address user1;
    address user2;
    event Deposit(address indexed dst, uint wad);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Withdrawal(address indexed src, uint wad);
    function setUp() public {
        Weth = new WETH();
        user1=makeAddr("art");
        user2=makeAddr("betty");
    }

    function test_Deposit() public {
        vm.startPrank(user1);
        deal(user1, 1 ether);

        //測項 1: deposit 應該將與 msg.value 相等的 ERC20 token mint 給 user
        Weth.deposit{value: 1 ether}();
        assertEq(Weth.balanceOf(user1), 1 ether);
        console.log("get weth balance from user1 after deposit");
        console.log(Weth.balanceOf(user1));

        //測項 2: deposit 應該將 msg.value 的 ether 轉入合約
        assertEq(address(Weth).balance, 1 ether);
        console.log("get eth balance from contract after deposit");
        console.log(Weth.balanceOf(user1));

        //測項 3: deposit 應該要 emit Deposit event
        deal(user1, 1 ether);
        vm.expectEmit(true,false,false,false,address(Weth));
        emit Deposit(user1, 1 ether);
        Weth.deposit{value: 1 ether}();

        vm.stopPrank();
    }

    function test_withdraw() public {
        vm.startPrank(user1);
        deal(user1, 1 ether);
        assertEq(address(user1).balance, 1 ether);
        Weth.deposit{value: 1 ether}();
        console.log("get weth balance from user1 before withdraw");
        console.log(Weth.balanceOf(user1));

        //測項 4: withdraw 應該要 burn 掉與 input parameters 一樣的 erc20 token
        //Weth.withdraw{wad: 1 ether}();
        //assertEq(Weth.balanceOf(user1),0);
        vm.expectCall(address(Weth), abi.encodeCall(Weth.withdraw, (1 ether)));
        Weth.withdraw(1 ether);
        assertEq(Weth.balanceOf(user1), 0);
        assertEq(address(user1).balance, 1 ether);
        console.log("get weth balance from user1 after withdraw");
        console.log(Weth.balanceOf(user1));
        
        //測項 5: withdraw 應該將 burn 掉的 erc20 換成 ether 轉給 user
        assertEq(Weth.balanceOf(user1), 0);
        assertEq(address(user1).balance, 1 ether);
        
        //測項 6: withdraw 應該要 emit Withdraw event
        deal(user1, 1 ether);
        Weth.deposit{value: 1 ether}();
        vm.expectEmit(true,false,false,false,address(Weth));
        emit Withdrawal(user1, 1 ether);
        Weth.withdraw(1 ether);
        
        vm.stopPrank();
    }

    function test_Erc20() public {
        vm.startPrank(user1);
        deal(user1, 2 ether);
        Weth.deposit{value: 1 ether}();
        //測項 7: transfer 應該要將 erc20 token 轉給別人
        vm.expectCall(address(Weth), abi.encodeCall(Weth.transfer, (user2,1 ether)));
        assertEq(Weth.transfer(user2,1 ether),true);
        assertEq(Weth.balanceOf(user1), 0);

        assertEq(Weth.balanceOf(user2), 1 ether);
        console.log("get weth balance from user1 after transfer");
        console.log(Weth.balanceOf(user1));
        console.log("get weth balance from user2 after transfer");
        console.log(Weth.balanceOf(user2));


        //測項 8: approve 應該要給他人 allowance
        assertEq(Weth.approve(user2,1 ether),true);
        assertEq(Weth.allowance(user1,user2),1 ether);
        console.log("get weth allowance from user1 to user2 after approve");
        console.log(Weth.allowance(user1,user2));

        //測項 9: transferFrom 應該要可以使用他人的 allowance
        deal(user1, 2 ether);
        Weth.deposit{value: 1 ether}();
        changePrank(user2);
        vm.expectCall(address(Weth), abi.encodeCall(Weth.transferFrom, (user1,user2,1 ether)));
        assertEq(Weth.transferFrom(user1,user2,1 ether),true);

        //測項 10: transferFrom 後應該要減除用完的 allowance
        assertEq(Weth.allowance(user1,user2),0);
        console.log("get weth allowance from user1 to user2 after transferFrom");
        console.log(Weth.allowance(user1,user2));
        vm.stopPrank();
        
        
    }

    
}
