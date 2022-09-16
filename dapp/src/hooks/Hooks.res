type graphResponse<'a> = Loading | GraphError(string) | Response('a)

let useGetTransactions = () => {
  let query = Queries.GetHodlerTokens.use()

  switch query {
  | {data: Some({transactions})} => Response(transactions)
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}
let useGetUserBalances = () => {
  let query = Queries.GetUserBalances.use()

  switch query {
  | {data: Some({hodlers})} => Response(hodlers)
  | {error: Some({message})} => GraphError(message)
  | _ => Loading
  }
}
