set shell := ["sh", "-c"]
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]
#set allow-duplicate-recipe
set positional-arguments
#set dotenv-filename := ".env"




deploy *ARGS:
    forge script script/foundry/DeployScript.s.sol:DeployColabX \
        --rpc-url $KINTO_RPC_URL \
        --account mainKey \
        --broadcast \
        --sender $DEPLOYER_ADDRESS \
        --etherscan-api-key 123 \
        --verify --verifier blockscout \
        --verifier-url $VERIFIER_KINTO_URL \
        --block-gas-limit 3000000000000000 -vvvvv \
        --gas-price 250000000 --force