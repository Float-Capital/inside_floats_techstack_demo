import { BigInt } from "@graphprotocol/graph-ts"
import {
  HodlWallet,
  Deposit,
  Withdraw
} from "../generated/HodlWallet/HodlWallet"
import { Hodler, Token, Transaction } from "../generated/schema"

export function handleDeposit(event: Deposit): void {


  // Entities can be loaded from the store using a string ID; this ID
  // needs to be unique across all entities of the same type
  let transaction = Transaction.load(event.transaction.hash.toHexString())

  // Entities only exist after they have been saved to the store;
  // `null` checks allow to create entities on demand
  if (!transaction) {
    transaction = new Transaction(event.transaction.hash.toHexString())
  }

  // BigInt and BigDecimal math are supported
  transaction.transactionType = "Deposit"

  // Entity fields can be set based on event parameters
  transaction.amount = event.params.amount
  transaction.timestamp = event.params.timestamp
  transaction.hodler = event.params.user.toHexString()
  transaction.token = event.params.token.toHexString()

  // Entities can be written to the store with `.save()`
  transaction.save()

  let token = Token.load(event.params.token.toHexString())

  if (!token) {
    token = new Token(event.params.token.toHexString())
    token.tokenAddress = event.params.token
    token.amount = BigInt.fromI32(0)
    token.hodler = event.params.user.toHexString()
  }
  token.amount = token.amount.plus(event.params.amount)
  token.timestamp = event.params.timestamp

  token.save()


  let hodler = Hodler.load(event.params.user.toHexString())

  if (!hodler) {
    hodler = new Hodler(event.params.user.toHexString())
    hodler.ethAddress = event.params.user.toHexString()
    hodler.save()
  }



  // Note: If a handler doesn't require existing field values, it is faster
  // _not_ to load the entity from the store. Instead, create it fresh with
  // `new Entity(...)`, set the fields that should be updated and save the
  // entity back to the store. Fields that were not set or unset remain
  // unchanged, allowing for partial updates to be applied.

  // It is also possible to access smart contracts from mappings. For
  // example, the contract that has emitted the event can be connected to
  // with:
  //
  // let contract = Contract.bind(event.address)
  //
  // The following functions can then be called on this contract to access
  // state variables and other data:
  //
  // - contract.lockUpTime(...)
  // - contract.userTokens(...)
}

export function handleWithdraw(event: Withdraw): void {

  // Entities can be loaded from the store using a string ID; this ID
  // needs to be unique across all entities of the same type
  let transaction = Transaction.load(event.transaction.hash.toHexString())

  // Entities only exist after they have been saved to the store;
  // `null` checks allow to create entities on demand
  if (!transaction) {
    transaction = new Transaction(event.transaction.hash.toHexString())
  }

  // BigInt and BigDecimal math are supported
  transaction.transactionType = "Withdraw"

  // Entity fields can be set based on event parameters
  transaction.amount = event.params.amount
  transaction.timestamp = event.params.timestamp
  transaction.hodler = event.params.user.toHexString()
  transaction.token = event.params.token.toHexString()

  // Entities can be written to the store with `.save()`
  transaction.save()

  let token = Token.load(event.params.token.toHexString())

  if (token) {
    token.amount = token.amount.minus(event.params.amount)
    token.save()
  }


  let hodler = Hodler.load(event.params.user.toHexString())

  if (!hodler) {
    hodler = new Hodler(event.params.user.toHexString())
    hodler.ethAddress = event.params.user.toHexString()
    hodler.save()
  }
}
