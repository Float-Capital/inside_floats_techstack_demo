@react.component
let make = () => {
  let transactions = Hooks.useGetTransactions()

  switch transactions {
  | Response(transactions) =>
    <div className="rounded-xl border shadow p-4 m-4">
      <h1 className="w-full text-center text-xl font-bold my-4">
        {"Transactions"->React.string}
      </h1>
      <table>
        <tr>
          <th className="pr-4"> {"Transaction"->React.string} </th>
          <th> {"Amount"->React.string} </th>
          <th> {"User"->React.string} </th>
          <th> {"Tx Link"->React.string} </th>
        </tr>
        {transactions
        ->Array.map(transaction =>
          <tr key={transaction.id}>
            <td> {transaction.transactionType->React.string} </td>
            <td> {transaction.amount->Js.Json.decodeString->Option.getUnsafe->React.string} </td>
            <td> {transaction.hodler.id->React.string} </td>
            <a
              className="text-blue-400 hover:underline hover:brightenes-110 px-4"
              href={"https://testnet.snowtrace.io/tx/" ++ transaction.id}
              target="_blank"
              rel="no-refer">
              {"View Tx"->React.string}
            </a>
          </tr>
        )
        ->React.array}
      </table>
    </div>
  | Loading => <div> {"Loading"->React.string} </div>
  | GraphError(msg) => <div> {msg->React.string} </div>
  }
}
