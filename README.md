1.CLONE專案  
git clone https://github.com/aechen1202/WETH.git

2.CD道專案資料夾
cd WETH

3.單元測試專案  
因為我下了很多log查看紀錄  
forge test --v  
  
4.預期結果  
Running 3 tests for test/WETH.t.sol:WETHTest  
[PASS] test_Deposit() (gas: 62151)  
Logs:  
  get weth balance from user1 after deposit  
  1000000000000000000  
  get eth balance from contract after deposit  
  1000000000000000000  
  
[PASS] test_Erc20() (gas: 117931)  
Logs:  
  get weth balance from user1 after transfer  
  0  
  get weth balance from user2 after transfer  
  1000000000000000000  
  get weth allowance from user1 to user2 after approve  
  1000000000000000000  
  changePrank is deprecated. Please use vm.startPrank instead.  
  get weth allowance from user1 to user2 after transferFrom  
  0  
  
[PASS] test_withdraw() (gas: 119087)  
Logs:  
  get weth balance from user1 before withdraw  
  1000000000000000000  
  get weth balance from user1 after withdraw  
  0  

Test result: ok. 3 passed; 0 failed; 0 skipped; finished in 52.07ms  
  
Ran 1 test suites: 3 tests passed, 0 failed, 0 skipped (3 total tests)  
