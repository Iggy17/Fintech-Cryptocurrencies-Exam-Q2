const CoToken = artifacts.require("./CoToken.sol");


contract("CoToken", function(accounts){
    //initialized parameters
    const buyer = accounts[0]
    var mintCount = 10;
    var burnCount = 6;


    context("facilitates the miniting of a token", function () {
        it("token contract correctly mints the correct number of tokens", async () => {
            // instantiate contract
            let CoTokenInstance = await CoToken.deployed()
            let numberOfTokens = await CoTokenInstance.balanceOf(buyer)

            await CoTokenInstance.mint(mintCount, { from: buyer })
            let balanceOfTokens = await CoTokenInstance.balanceOf(buyer)
            // ensure balance of tokens changes to the new balance including minted tokens
            assert.equal(balanceOfTokens.toNumber(), mintCount, "Incorrect number of tokens minted")

        })

        it("token contract correctly burns the correct number of tokens", async () => {
            let CoTokenInstance = await CoToken.deployed()
            let numberOfTokens = await CoTokenInstance.balanceOf(buyer)

            await CoTokenInstance.burn(burnCount, { from: buyer })

            let tokenBalance = await CoTokenInstance.balanceOf(buyer)
            let tokenCount = numberOfTokens - burnCount
            //make sure new balance corresponds to burnt tokens
            assert.equal(tokenBalance.toNumber(), tokenCount, "Incorrect number of tokens burned")
        })
    })
})
