module GetHodlerTokens = %graphql(`
query  GetHodlerTokens {
  transactions {
    id
    transactionType
 	timestamp
    amount
    hodler {
        id
    }
  }
}
`)
module GetUserBalances = %graphql(`
query  GetUserBalances {
  hodlers {
    id
    tokens {
        id
        amount
    }
  }
}
`)
