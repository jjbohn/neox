defmodule NeoxTest do
  defmodule User do
    defstruct name: nil, email: nil
  end

  import Neox.Query
  use ExUnit.Case

  test "the truth" do
    create(john: %User{name: "John", email: "jjbohn@gmail.com"})
    |> flush

    match(john: %User{name: "John"})
    |> delete(:john)

    match(users: %User{})
    |> delete(:users)

    # DROP CONSTRAINT ON (book:Book) ASSERT book.isbn IS UNIQUE

    #drop_constraint(store: %Store{}) assert store.name is unique

    # create(%{john: %User{name: "john"}})
    # |> create(%{marie: %User{name: "marie"}})
    # |> return(:john)


    # match({john: %{User{name: "John"}}, marie: %{User{name: "Marie"}}})
    # |> create_unique(:john, -%{Married}->, :marie)

    # match({me: %{User}})
    # |> return
  end
end
