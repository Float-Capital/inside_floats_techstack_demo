@react.component
let make = () => {
  let transactions = Hooks.useGetUserBalances()

  switch transactions {
  | Response(hodlers) =>
    <div className="rounded-xl border shadow p-4 m-4">
      <h1 className="w-full text-center text-xl font-bold my-4"> {"Balances"->React.string} </h1>
      <table>
        <tr>
          <th className="pr-4 text-left"> {"Token"->React.string} </th>
          <th> {"Balance"->React.string} </th>
        </tr>
        {hodlers
        ->Array.map(hodler =>
          hodler.tokens
          ->Array.map(token => {
            <tr key={token.id}>
              <td> {token.id->React.string} </td>
              <td className="px-4">
                {token.amount->Js.Json.decodeString->Option.getUnsafe->React.string}
              </td>
            </tr>
          })
          ->React.array
        )
        ->React.array}
      </table>
    </div>
  | _ => React.null
  }
}
